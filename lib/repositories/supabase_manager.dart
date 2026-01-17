import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import '../models/todo_model.dart';

/// --------------------
/// SUPABASE MANAGER
/// --------------------
class SupabaseManager {
  static const String _tableName = 'todos';
  final SupabaseClient _client;
  bool isFirstLoad = true;
  final _todoStreamController = StreamController<List<Todo>>.broadcast();
  StreamSubscription? _streamSubscription;

  SupabaseManager({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client {
    _initializeStream();
  }

  /// INSERT a new todo
  Future<Todo> insert(Todo todo) async {
    try {
      final response = await _client.from(_tableName).insert({
        'id': todo.id,
        'text': todo.text,
        'is_completed': todo.isCompleted,
        'created_at': todo.createdAt.toIso8601String(),
      }).select();

      if (response.isEmpty) {
        throw Exception('Failed to insert todo');
      }

      return _fromJson(response.first);
    } catch (e) {
      throw Exception('Error inserting todo: $e');
    }
  }

  /// UPDATE an existing todo
  Future<Todo> update(Todo todo) async {
    try {
      final response = await _client
          .from(_tableName)
          .update({'text': todo.text, 'is_completed': todo.isCompleted})
          .eq('id', todo.id)
          .select();

      if (response.isEmpty) {
        throw Exception('Failed to update todo');
      }

      return _fromJson(response.first);
    } catch (e) {
      throw Exception('Error updating todo: $e');
    }
  }

  /// DELETE a todo
  Future<void> delete(String id) async {
    try {
      await _client.from(_tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Error deleting todo: $e');
    }
  }

  /// GET a single todo by id
  Future<Todo?> getById(String id) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .limit(1);

      if (response.isEmpty) {
        return null;
      }

      return _fromJson(response.first);
    } catch (e) {
      throw Exception('Error fetching todo: $e');
    }
  }

  /// CONVERT from JSON to Todo model
  Todo _fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      text: json['text'] as String,
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  /// CONVERT from Todo model to JSON
  Map<String, dynamic> toJson(Todo todo) {
    return {
      'id': todo.id,
      'text': todo.text,
      'is_completed': todo.isCompleted,
      'created_at': todo.createdAt.toIso8601String(),
    };
  }

  /// REAL-TIME STREAM - Listen to all todos changes (insert, update, delete)
  Stream<List<Todo>> streamAllTodos() {
    return _todoStreamController.stream;
  }

  /// Initialize persistent stream subscription
  void _initializeStream() {
    try {
      print('[SupabaseManager] Initializing real-time stream...');

      _streamSubscription = _client
          .from(_tableName)
          .stream(primaryKey: ['id'])
          .listen(
            (data) {
              try {
                final todos = (data as List<dynamic>)
                    .map((item) => _fromJson(item as Map<String, dynamic>))
                    .toList();
                print(
                  '[SupabaseManager] ✅ Stream update received: ${todos.length} items',
                );
                _todoStreamController.add(todos);
              } catch (e) {
                print('[SupabaseManager] ❌ Error processing stream data: $e');
                _todoStreamController.addError(e);
              }
            },
            onError: (error) {
              print('[SupabaseManager] ❌ Stream error: $error');
              _todoStreamController.addError(error);
            },
            onDone: () {
              print('[SupabaseManager] ⚠️ Stream closed, reinitializing...');
              Future.delayed(const Duration(seconds: 2), _initializeStream);
            },
            cancelOnError: false,
          );
    } catch (e) {
      print('[SupabaseManager] ❌ Error initializing stream: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _streamSubscription?.cancel();
    _todoStreamController.close();
  }
}

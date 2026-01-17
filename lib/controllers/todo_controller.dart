import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';
import '../repositories/supabase_manager.dart';

class TodoController extends GetxController {
  final SupabaseManager supabaseManager;
  TodoController(this.supabaseManager);

  final todos = <Todo>[].obs;
  final input = ''.obs;
  String? editingId;
  var highlightedId = ''.obs;
  final textController = TextEditingController();

  //late SupabaseManager supabaseManager;

  @override
  void onInit() {
    super.onInit();
    try {
      print('[TodoController] Subscribing to real-time todos...');
      // Listen to real-time changes from Supabase
      supabaseManager.streamAllTodos().listen(
        (data) {
          print('[TodoController] ✅ Received ${data.length} todos');
          todos.value = data;
        },
        onError: (error) {
          print('[TodoController] ❌ Stream error: $error');
        },
        onDone: () {
          print('[TodoController] ⚠️ Stream closed');
        },
      );
    } catch (e) {
      print('[TodoController] ❌ Error initializing streams: $e');
    }
  }

  @override
  void onClose() {
    supabaseManager.dispose();
    super.onClose();
  }

  Color generateColorByIndex(int index) {
    final colors = [
      const Color(0xFFFFF9F9), // Barely Red
      const Color(0xFFFFFBF2), // Barely Orange
      const Color(0xFFFFFFF5), // Barely Yellow
      const Color(0xFFF9FFF9), // Barely Green
      const Color(0xFFF7FBFF), // Barely Blue
      const Color(0xFFFBF9FF), // Barely Purple
      const Color(0xFFFFF9FB), // Barely Pink
      const Color(0xFFF5FFFF), // Barely Cyan
    ];
    return colors[index % colors.length];
  }

  List<Todo> get filteredTodos {
    final list = input.value.isEmpty
        ? todos.toList()
        : todos
              .where(
                (t) => t.text.toLowerCase().contains(input.value.toLowerCase()),
              )
              .toList();

    // Sort by latest created (descending)
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  int get activeCount => todos.where((t) => !t.isCompleted).length;

  void onTextChanged(String value) {
    if (value.trim().isNotEmpty) input.value = value;
  }

  void submit() {
    final value = input.value.trim();

    final duplicateItem = todos.firstWhereOrNull((t) {
      final sameText = t.text.toLowerCase() == value.toLowerCase();
      final differentEditing = t.id != editingId;
      return sameText && differentEditing;
    });

    if (duplicateItem != null) {
      highlightedId.value = duplicateItem.id;
      Get.snackbar(
        'Duplicate task',
        'This task is already in your list.',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        backgroundColor: Colors.amber.shade50,
        colorText: Colors.amber.shade900,
        icon: const Icon(Icons.info_outline_rounded, color: Colors.amber),
        isDismissible: true,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (editingId == null) {
      final newTodo = Todo(id: const Uuid().v4(), text: value);
      // Add to UI immediately for better UX
      todos.add(newTodo);
      // Save to Supabase async
      supabaseManager
          .insert(newTodo)
          .then((_) {
            // Success - item already in UI
          })
          .catchError((e) {
            // Rollback on error
            todos.removeWhere((t) => t.id == newTodo.id);
            Get.snackbar(
              'Error',
              'Failed to add task: $e',
              snackPosition: SnackPosition.TOP,
            );
          });
    } else {
      final index = todos.indexWhere((t) => t.id == editingId);
      if (index != -1) {
        final updatedTodo = Todo(
          id: todos[index].id,
          text: value,
          isCompleted: todos[index].isCompleted,
          createdAt: todos[index].createdAt,
        );
        // Update immediately in local list
        todos[index] = updatedTodo;
        // Update in Supabase async
        supabaseManager
            .update(updatedTodo)
            .then((_) {
              // Success - item already updated in UI
            })
            .catchError((e) {
              // Reload from DB on error
              todos.refresh();
              Get.snackbar(
                'Error',
                'Failed to update task: $e',
                snackPosition: SnackPosition.TOP,
              );
            });
        editingId = null;
      }
    }

    input.value = '';
  }

  void edit(Todo todo) {
    editingId = todo.id;
    input.value = todo.text;
  }

  void remove(String id) {
    // Remove from UI immediately
    final removedTodo = todos.firstWhereOrNull((t) => t.id == id);
    todos.removeWhere((t) => t.id == id);
    // Delete from Supabase async
    supabaseManager.delete(id).catchError((e) {
      // Restore on error
      if (removedTodo != null) {
        todos.add(removedTodo);
      }
      Get.snackbar(
        'Error',
        'Failed to delete task: $e',
        snackPosition: SnackPosition.TOP,
      );
    });
  }

  void toggleComplete(Todo todo) {
    final updatedTodo = Todo(
      id: todo.id,
      text: todo.text,
      isCompleted: !todo.isCompleted,
      createdAt: todo.createdAt,
    );
    // Update immediately in local list
    final index = todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      todos[index] = updatedTodo;
    }
    // Update in Supabase async
    supabaseManager
        .update(updatedTodo)
        .then((_) {
          // Success - item already updated in UI
        })
        .catchError((e) {
          // Revert on error
          final idx = todos.indexWhere((t) => t.id == todo.id);
          if (idx != -1) {
            todos[idx] = todo;
          }
          Get.snackbar(
            'Error',
            'Failed to update task: $e',
            snackPosition: SnackPosition.TOP,
          );
        });
  }
}

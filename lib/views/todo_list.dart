import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/todo_controller.dart';
import '../repositories/supabase_manager.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  TodoList({super.key});

  final supabaseManager = Get.find<SupabaseManager>();
  final controller = Get.find<TodoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.filteredTodos.isEmpty) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox, size: 64, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'No result. Create a new one instead',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.filteredTodos.length,
        //reverse: true,
        itemBuilder: (_, index) {
          return TodoItem(
            todo: controller.filteredTodos[index],
            controller: controller,
          );
        },
      );
    });
  }
}

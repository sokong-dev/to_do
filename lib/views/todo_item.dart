import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/util/custom_dialog.dart';
import '../controllers/todo_controller.dart';
import '../image_path/icon_app.dart';
import '../models/todo_model.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.todo, required this.controller});

  final Todo todo;
  final TodoController controller;

  String _formatDate(DateTime date) {
    // Convert to Cambodia Time (UTC+7)
    final cambodiaTime = date.toUtc().add(const Duration(hours: 7));

    final hour = cambodiaTime.hour;
    final minute = cambodiaTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';

    // Convert 24h to 12h
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: controller.generateColorByIndex(
            controller.todos.indexOf(todo),
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
        child: InkWell(
          onTap: () => controller.toggleComplete(todo),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Custom Animated Checkbox
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: todo.isCompleted
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: todo.isCompleted
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: todo.isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 16),

                // Todo Text and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.text,
                        style: TextStyle(
                          fontSize: 15,
                          color: todo.isCompleted
                              ? Colors.grey
                              : const Color(0xFF2D2D2D),
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: Colors.grey,
                          fontWeight: todo.isCompleted
                              ? FontWeight.normal
                              : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(todo.createdAt),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Image.asset(IconApp.edit, width: 20, height: 20),
                      color: Colors.grey.shade700,
                      tooltip: 'Edit task',

                      padding: const EdgeInsets.all(8),
                      onPressed: () => controller.edit(todo),
                    ),
                    IconButton(
                      icon: Image.asset(IconApp.delete, width: 20, height: 20),
                      color: Colors.red.shade400,
                      tooltip: 'Remove task',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                      onPressed: () async {
                        await CustomShowDialog.showWarning(
                          context: context,
                          type: DialogType.warning,
                          title: 'Remove task',
                          //content: 'Are you sure you want to remove this task?',
                          confirmText: 'Remove',
                          cancelText: 'Cancel',
                          onConfirm: () {
                            controller.remove(todo.id);
                            Get.back(result: true);
                          },
                          onCancel: () => Get.back(result: false),
                        );
                      
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

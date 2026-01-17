import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import 'input_card.dart';
import 'todo_list.dart';

/// --------------------
/// PAGE
/// --------------------
class HomeView extends StatelessWidget {
  HomeView({super.key});
  final controller = Get.find<TodoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Today\'s Tasks',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(() {
                        final count = controller.activeCount;
                        final hasActive = count > 0;
                        final color = hasActive
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade500;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: hasActive
                                ? color.withOpacity(0.08)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, size: 14, color: color),
                              const SizedBox(width: 4),
                              Text(
                                '$count active',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a new task or search your list below.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InputCard(
                    controller: controller,
                    textController: controller.textController,
                  ),
                ],
              ),
            ),
            Expanded(child: TodoList()),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        return FloatingActionButton(
          isExtended: true,
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: controller.input.isEmpty ? null : controller.submit,
          backgroundColor: controller.input.isEmpty
              ? Colors.grey
              : Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: Icon(controller.editingId == null ? Icons.add : Icons.check),
        );
      }),
    );
  }
}

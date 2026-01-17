// import 'package:flutter_test/flutter_test.dart';
// import 'package:get/get.dart';
// import 'package:to_do/controllers/todo_controller.dart';
// import 'package:to_do/repositories/itodo_repository.dart';
// import 'package:to_do/repositories/memory_todo_repository.dart';

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//   late TodoController controller;

//   setUp(() {
//     Get.reset(); // Reset dependencies
//     Get.testMode = true;
//     Get.put<ITodoRepository>(MemoryTodoRepository());
//     controller = Get.put(TodoController());
//   });

//   group('TodoController Tests', () {
//     test('Initial state should be empty', () {
//       expect(controller.todos.length, 0);
//     });

//     test('Add Todo should add item', () async {
//       bool result = await controller.ad('Buy Milk');
//       expect(result, true);
//       expect(controller.todos.length, 1);
//       expect(controller.todos[0].title, 'Buy Milk');
//     });

//     test('Add empty Todo should fail', () async {
//       bool result = await controller.addTodo('   ');
//       expect(result, false);
//       expect(controller.todos.length, 0);
//     });

//     test('Add duplicate Todo should fail', () async {
//       await controller.addTodo('Buy Milk');
//       bool result = await controller.addTodo('Buy Milk');
//       expect(result, false);
//       expect(controller.todos.length, 1);
//     });

//     test('Remove Todo should remove item', () async {
//       await controller.addTodo('Buy Milk');
//       String id = controller.todos[0].id;
//       await controller.removeTodo(id);
//       expect(controller.todos.length, 0);
//     });

//     test('Toggle Complete should change status', () async {
//       await controller.addTodo('Buy Milk');
//       String id = controller.todos[0].id;
//       expect(controller.todos[0].isCompleted, false);

//       await controller.toggleComplete(id);
//       expect(controller.todos[0].isCompleted, true);

//       await controller.toggleComplete(id);
//       expect(controller.todos[0].isCompleted, false);
//     });

//     test('Update Todo should change title', () async {
//       await controller.addTodo('Buy Milk');
//       String id = controller.todos[0].id;

//       bool result = await controller.updateTodo(id, 'Buy Eggs');
//       expect(result, true);
//       expect(controller.todos[0].title, 'Buy Eggs');
//     });

//     test('Update Todo to empty should fail', () async {
//       await controller.addTodo('Buy Milk');
//       String id = controller.todos[0].id;

//       bool result = await controller.updateTodo(id, '');
//       expect(result, false);
//       expect(controller.todos[0].title, 'Buy Milk');
//     });

//     test('Update Todo to existing title should fail', () async {
//       await controller.addTodo('Buy Milk');
//       await controller.addTodo('Buy Eggs');
//       String id = controller.todos[0].id; // Buy Milk

//       bool result = await controller.updateTodo(id, 'Buy Eggs');
//       expect(result, false);
//       expect(controller.todos[0].title, 'Buy Milk');
//     });

//     test('Filter should filter todos', () async {
//       await controller.addTodo('Buy Milk');
//       await controller.addTodo('Buy Eggs');
//       await controller.addTodo('Walk Dog');

//       controller.setFilter('Buy');
//       expect(controller.filteredTodos.length, 2);

//       controller.setFilter('Milk');
//       expect(controller.filteredTodos.length, 1);
//       expect(controller.filteredTodos[0].title, 'Buy Milk');

//       controller.setFilter('');
//       expect(controller.filteredTodos.length, 3);
//     });
//   });
// }

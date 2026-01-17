import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import '../repositories/supabase_manager.dart';

class TodoBinding extends Bindings {
  @override
  void dependencies() {
    // Inject Repository
    Get.lazyPut<SupabaseManager>(() => SupabaseManager(), fenix: true);

    // Inject Controller
    Get.lazyPut<TodoController>(
      () => TodoController(Get.find<SupabaseManager>()),
      fenix: true,
    );
  }
}

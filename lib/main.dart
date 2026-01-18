import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'bindings/todo_binding.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with proper URL format
  await Supabase.initialize(
    url: 'https://nejchinhwxwvxjngscsc.supabase.co',
    anonKey: 'sb_publishable_vIw1KFdeXK81-JA_e42KQw_2CczfJMy',
  );

  // Initialize GetX bindings before running app
  TodoBinding().dependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planize',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF31A24C),
      ),
      home: HomeView(),
    );
  }
}

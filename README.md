# VTech Todo Challenge

This is a Flutter Todo application built for the VTech Coding Challenge.

## Features

- **Basic Requirement**: Todo list with Input and List elements.
- **State Management**: Uses **GetX** for state management.
- **Validations**: Prevents empty and duplicate todos.
- **Functionalities**:
  - Add Todo (Enter key)
  - Remove Todo (Delete button)
  - Edit Todo (Edit button -> Update button)
  - Mark as Complete/Incomplete
  - Filter Todo (Type in input box)
- **Bonus**:
  - **Repository Pattern**: Implemented `ITodoRepository` to abstract data source.
  - **Database Sync**: `FirebaseTodoRepository` code provided in `lib/repositories/firebase_todo_repository.dart` (commented out to avoid build errors without config).

## Project Structure

- `lib/models/`: Data models (`Todo`).
- `lib/views/`: UI screens (`HomeView`).
- `lib/controllers/`: State management (`TodoController`).
- `lib/repositories/`: Data access layer (`ITodoRepository`, `MemoryTodoRepository`, `FirebaseTodoRepository`).
- `test/`: Unit tests for controller logic.

## How to Run

1.  Clone the repository.
2.  Run `flutter pub get`.
3.  Run `flutter run`.

## How to Run Tests

Run `flutter test` to verify the logic.

## Enabling Firebase Sync (Bonus)

To enable real-time synchronization with Firebase:

1.  Add `firebase_core` and `cloud_firestore` to `pubspec.yaml`.
2.  Uncomment the code in `lib/repositories/firebase_todo_repository.dart`.
3.  Configure Firebase for your platform (iOS/Android/Web) using `flutterfire configure`.
4.  In `lib/main.dart`, initialize Firebase:
    ```dart
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    ```
5.  In `lib/main.dart`, replace `MemoryTodoRepository` with `FirebaseTodoRepository`:
    ```dart
    Get.put<ITodoRepository>(FirebaseTodoRepository());
    ```

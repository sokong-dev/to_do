# Flutter Todo App 

A modern Flutter Todo application with real-time synchronization powered by **Supabase** and **GetX** state management.

## ✨ Features

- Add, Edit, and Delete tasks
- Mark tasks as complete/incomplete
- Real-time filtering/search
- Real-time sync across all devices using Supabase
- Color-coded tasks with pastel colors
- Duplicate detection with visual feedback
- Form validation to prevent empty tasks
- Optimistic updates for instant UI feedback
- Active task counter

## � State Management

This app uses **GetX** for state management, providing:

- **Reactive Programming** - Observable variables (`.obs`) for automatic UI updates
- **Dependency Injection** - GetX bindings for clean dependency management
- **Routing** - GetX navigation system
- **Snackbars & Dialogs** - Built-in UI feedback mechanisms

Example state management in `TodoController`:
```dart
final todos = <Todo>[].obs;  // Observable list
final input = ''.obs;        // Observable input

void submit() {
  // UI updates automatically when todos changes
  todos.add(newTodo);
}
```

## 🔄 Database Sync

**Supabase** is used as the backend database with real-time synchronization:

- **PostgreSQL Database** - Robust relational database
- **Real-time Streams** - Instant updates across all connected clients
- **REST API** - CRUD operations through Supabase client

The `SupabaseManager` handles all database operations:
```dart
// Real-time streaming
_client.from('todos').stream(primaryKey: ['id']).listen((data) {
  // Auto-updates UI when database changes
});
```

Database Schema:
```sql
CREATE TABLE todos (
  id TEXT PRIMARY KEY,
  text TEXT NOT NULL,
  is_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 📚 Libraries

Key dependencies from `pubspec.yaml`:

| Package | Version | Purpose |
|---------|---------|---------|
| `get` | ^4.7.3 | State management, routing, and dependency injection |
| `supabase_flutter` | ^2.5.0 | Backend integration and real-time database sync |
| `uuid` | ^4.5.2 | Generate unique IDs for todos |
| `font_awesome_flutter` | ^10.7.0 | Icon library |
| `flutter_svg` | latest | SVG asset support |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |

## � Getting Started

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure Supabase** in `lib/main.dart`:
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

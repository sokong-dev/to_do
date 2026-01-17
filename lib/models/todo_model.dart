/// --------------------
/// MODEL
/// --------------------
class Todo {
  final String id;
  String text;
  bool isCompleted;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.text,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

import 'dart:convert';

enum TaskPriority {
  low,
  medium,
  high;

  String toJson() => name;
  static TaskPriority fromJson(String json) => 
      TaskPriority.values.firstWhere((e) => e.name == json);
}

class TaskItem {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final TaskPriority priority;
  final String category;
  final DateTime createdAt;

  TaskItem({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.category = 'General',
    required this.createdAt,
  });

  TaskItem copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    String? category,
  }) {
    return TaskItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        'priority': priority.toJson(),
        'category': category,
        'createdAt': createdAt.toIso8601String(),
      };

  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        isCompleted: json['isCompleted'] ?? false,
        priority: TaskPriority.fromJson(json['priority'] ?? 'medium'),
        category: json['category'] ?? 'General',
        createdAt: DateTime.parse(json['createdAt']),
      );
}

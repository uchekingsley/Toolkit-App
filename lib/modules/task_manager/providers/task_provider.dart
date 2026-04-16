import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/task_item.dart';

class TaskNotifier extends Notifier<List<TaskItem>> {
  static const _storageKey = 'tasks_data';
  late SharedPreferences _prefs;

  @override
  List<TaskItem> build() {
    _init();
    return [];
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final savedData = _prefs.getStringList(_storageKey);
    if (savedData != null) {
      state = savedData
          .map((item) => TaskItem.fromJson(json.decode(item)))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
  }

  void addTask({
    required String title,
    String description = '',
    TaskPriority priority = TaskPriority.medium,
    String category = 'General',
  }) {
    final newItem = TaskItem(
      id: const Uuid().v4(),
      title: title,
      description: description,
      priority: priority,
      category: category,
      createdAt: DateTime.now(),
    );
    state = [newItem, ...state];
    _save();
  }

  void toggleTask(String id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(isCompleted: !task.isCompleted) else task,
    ];
    _save();
  }

  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
    _save();
  }

  void editTask({
    required String id,
    String? title,
    String? description,
    TaskPriority? priority,
    String? category,
  }) {
    state = [
      for (final task in state)
        if (task.id == id)
          task.copyWith(
            title: title,
            description: description,
            priority: priority,
            category: category,
          )
        else
          task,
    ];
    _save();
  }

  Future<void> _save() async {
    final encoded = state.map((item) => json.encode(item.toJson())).toList();
    await _prefs.setStringList(_storageKey, encoded);
  }
}

final taskProvider = NotifierProvider<TaskNotifier, List<TaskItem>>(() {
  return TaskNotifier();
});

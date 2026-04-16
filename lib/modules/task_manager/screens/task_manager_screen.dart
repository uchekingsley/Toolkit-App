import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../shared/widgets/dynamic_background.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../../shared/widgets/glass_pane.dart';
import '../../../shared/widgets/animated_input_field.dart';
import '../../../shared/services/haptic_service.dart';
import '../providers/task_provider.dart';
import '../models/task_item.dart';
import '../widgets/task_card.dart';
import '../widgets/add_task_sheet.dart';

class TaskManagerScreen extends ConsumerStatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  ConsumerState<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends ConsumerState<TaskManagerScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddSheet([TaskItem? existingTask]) {
    HapticService.medium();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskSheet(
        initialTask: existingTask,
        onSave: ({required title, required description, required priority, required category}) {
          if (existingTask == null) {
            ref.read(taskProvider.notifier).addTask(
                  title: title,
                  description: description,
                  priority: priority,
                  category: category,
                );
          } else {
            ref.read(taskProvider.notifier).editTask(
                  id: existingTask.id,
                  title: title,
                  description: description,
                  priority: priority,
                  category: category,
                );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final filteredTasks = tasks.where((t) {
      final matchesQuery = t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesQuery;
    }).toList();

    final completedCount = tasks.where((t) => t.isCompleted).length;
    final totalCount = tasks.length;
    final completionRate = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: 'Task Manager', showBackButton: true),
      body: DynamicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildStatsHeader(completionRate, completedCount, totalCount),
              _buildSearchBar(),
              Expanded(
                child: filteredTasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        itemCount: filteredTasks.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return TaskCard(
                            task: task,
                            onToggle: () => ref.read(taskProvider.notifier).toggleTask(task.id),
                            onDelete: () => ref.read(taskProvider.notifier).deleteTask(task.id),
                            onEdit: () => _showAddSheet(task),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ).animate().scale(delay: 500.ms),
    );
  }

  Widget _buildStatsHeader(double rate, int completed, int total) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GlassPane(
        padding: const EdgeInsets.all(20),
        borderRadius: 24,
        child: Row(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 30,
                  startDegreeOffset: -90,
                  sections: [
                    PieChartSectionData(
                      color: Theme.of(context).colorScheme.primary,
                      value: rate * 100,
                      title: '',
                      radius: 8,
                    ),
                    PieChartSectionData(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      value: (1 - rate) * 100,
                      title: '',
                      radius: 8,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Productivity',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(rate * 100).toInt()}% of tasks completed',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$completed / $total completed',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: -0.1),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: AnimatedInputField(
        controller: _searchController,
        hintText: 'Search tasks or categories...',
        fontSize: 16,
        onChanged: (val) => setState(() => _searchQuery = val),
        prefixIcon: Icon(LucideIcons.search, size: 18, color: Theme.of(context).colorScheme.primary),
        keyboardType: TextInputType.text,
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isEmpty ? LucideIcons.clipboardList : LucideIcons.searchX,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No tasks yet' : 'No results found',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Tap + to add a new task',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ).animate().fadeIn(),
    );
  }
}

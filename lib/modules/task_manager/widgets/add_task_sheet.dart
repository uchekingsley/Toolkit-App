import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../shared/widgets/glass_pane.dart';
import '../../../shared/widgets/animated_input_field.dart';
import '../../../shared/services/haptic_service.dart';
import '../../../shared/styles/app_styles.dart';
import '../models/task_item.dart';

class AddTaskSheet extends StatefulWidget {
  final TaskItem? initialTask;
  final Function({
    required String title,
    required String description,
    required TaskPriority priority,
    required String category,
  }) onSave;

  const AddTaskSheet({
    super.key,
    this.initialTask,
    required this.onSave,
  });

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _categoryController;
  late TaskPriority _priority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTask?.title ?? '');
    _descController = TextEditingController(text: widget.initialTask?.description ?? '');
    _categoryController = TextEditingController(text: widget.initialTask?.category ?? 'General');
    _priority = widget.initialTask?.priority ?? TaskPriority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: GlassPane(
        borderRadius: 32,
        padding: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(context).viewInsets.bottom +
                MediaQuery.of(context).padding.bottom +
                24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.initialTask == null ? 'New Task' : 'Edit Task',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(LucideIcons.x),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AnimatedInputField(
                  controller: _titleController,
                  label: 'TASK TITLE',
                  hintText: 'What needs to be done?',
                  fontSize: 18,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  prefixIcon: const Icon(LucideIcons.type, size: 20),
                ),
                const SizedBox(height: 20),
                AnimatedInputField(
                  controller: _descController,
                  label: 'DESCRIPTION',
                  hintText: 'Add some details...',
                  fontSize: 16,
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
                  prefixIcon: const Icon(LucideIcons.alignLeft, size: 20),
                ),
                const SizedBox(height: 20),
                AnimatedInputField(
                  controller: _categoryController,
                  label: 'CATEGORY',
                  hintText: 'e.g. Work, Home, HNG',
                  fontSize: 16,
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(LucideIcons.tag, size: 20),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Priority',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  children: TaskPriority.values.map((p) {
                    final isSelected = _priority == p;
                    Color color;
                    switch (p) {
                      case TaskPriority.high:
                        color = AppColors.danger;
                        break;
                      case TaskPriority.medium:
                        color = AppColors.warning;
                        break;
                      case TaskPriority.low:
                        color = AppColors.secondary;
                        break;
                    }

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () {
                            HapticService.selection();
                            setState(() => _priority = p);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? color : color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? color : color.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                p.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.isNotEmpty) {
                          HapticService.medium();
                          widget.onSave(
                            title: _titleController.text,
                            description: _descController.text,
                            priority: _priority,
                            category: _categoryController.text,
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        widget.initialTask == null ? 'Create Task' : 'Save Changes',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

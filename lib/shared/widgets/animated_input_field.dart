import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// animated input field
class AnimatedInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? prefixText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;

  const AnimatedInputField({
    super.key,
    required this.controller,
    required this.label,
    this.prefixText,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            prefixText: prefixText,
            prefixStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

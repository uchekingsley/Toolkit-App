import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// animated input field
class AnimatedInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? prefixText;
  final String? hintText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final int maxLines;
  final double fontSize;
  final Widget? prefixIcon;
  final TextCapitalization textCapitalization;

  const AnimatedInputField({
    super.key,
    required this.controller,
    this.label,
    this.prefixText,
    this.hintText,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.onChanged,
    this.maxLines = 1,
    this.fontSize = 24,
    this.prefixIcon,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          maxLines: maxLines,
          textCapitalization: textCapitalization,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: fontSize * 0.7,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            prefixText: prefixText,
            prefixIcon: prefixIcon,
            prefixStyle: TextStyle(
              fontSize: fontSize,
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

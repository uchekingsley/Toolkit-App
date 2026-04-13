import 'dart:ui';
import 'package:flutter/material.dart';

class DynamicBackground extends StatelessWidget {
  final Widget child;

  const DynamicBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Layer
        Positioned.fill(
          child: Container(color: Theme.of(context).colorScheme.background),
        ),
        // Organic Blobs
        Positioned(
          top: -100,
          right: -50,
          child: _Blob(
            color: const Color(0xFF6366F1).withOpacity(0.15),
            size: 400,
          ),
        ),
        Positioned(
          bottom: -150,
          left: -100,
          child: _Blob(
            color: const Color(0xFF10B981).withOpacity(0.1),
            size: 500,
          ),
        ),
        Positioned(
          top: 200,
          left: -50,
          child: _Blob(
            color: const Color(0xFFF472B6).withOpacity(0.08),
            size: 300,
          ),
        ),
        // Blur Layer
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
        ),
        // Content
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;

  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class DynamicBackground extends StatefulWidget {
  final Widget child;

  const DynamicBackground({super.key, required this.child});

  @override
  State<DynamicBackground> createState() => _DynamicBackgroundState();
}

class _DynamicBackgroundState extends State<DynamicBackground> {
  double _offsetX = 0;
  double _offsetY = 0;
  StreamSubscription<AccelerometerEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      if (!mounted) return;
      setState(() {
        // Map accelerometer values to a subtle offset range (-20 to 20)
        // Adjust sensitivity: 0.2 multiplier
        _offsetX = (event.x * -2.0).clamp(-30.0, 30.0);
        _offsetY = (event.y * 2.0).clamp(-30.0, 30.0);
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Layer
        Positioned.fill(
          child: Container(color: Theme.of(context).colorScheme.background),
        ),
        // Organic Blobs with Parallax
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          top: -100 + _offsetY,
          right: -50 + _offsetX,
          child: _Blob(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            size: 400,
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          bottom: -150 - _offsetY,
          left: -100 - _offsetX,
          child: _Blob(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            size: 500,
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          top: 200 + (_offsetY * 0.5),
          left: -50 + (_offsetX * 0.5),
          child: _Blob(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.08),
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
        widget.child,
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

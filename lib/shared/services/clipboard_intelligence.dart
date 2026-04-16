import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/glass_pane.dart';
import 'haptic_service.dart';

class ClipboardIntelligence {
  static final ClipboardIntelligence _instance = ClipboardIntelligence._internal();
  factory ClipboardIntelligence() => _instance;
  ClipboardIntelligence._internal();

  bool _isChecking = false;

  void startChecking(BuildContext context) {
    if (_isChecking) return;
    _isChecking = true;
    
   
  }

  Future<void> checkClipboard(BuildContext context) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();

    if (text == null || text.isEmpty) return;

    // Pattern matching for numeric value + unit (e.g. "50 kg", "100 usd")
    final regex = RegExp(r'^(\d+(\.\d+)?)\s*([a-zA-Z\$€£]+)$');
    final match = regex.firstMatch(text.toLowerCase());

    if (match != null) {
      final value = match.group(1);
      final unit = match.group(3);
      
      if (context.mounted) {
        _showClipboardPrompt(context, value!, unit!);
      }
    }
  }

  void _showClipboardPrompt(BuildContext context, String value, String unit) {
    HapticService.medium();
    
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            tween: Tween(begin: -100.0, end: 0.0),
            curve: Curves.easeOutBack,
            builder: (context, offset, child) {
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            child: GlassPane(
              borderRadius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.content_paste, size: 20, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Found in clipboard',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Convert $value ${unit.toUpperCase()}?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      HapticService.light();
                      entry.remove();
                    },
                    child: const Text('VIEW'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => entry.remove(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    // Auto-remove after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (entry.mounted) entry.remove();
    });
  }
}

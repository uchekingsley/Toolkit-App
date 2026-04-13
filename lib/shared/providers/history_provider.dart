import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// history item model
class HistoryItem {
  final String title;
  final String result;
  final DateTime timestamp;

  HistoryItem({
    required this.title,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'result': result,
        'timestamp': timestamp.toIso8601String(),
      };

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        title: json['title'],
        result: json['result'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

// history notifier
class HistoryNotifier extends Notifier<List<HistoryItem>> {
  static const _historyKey = 'calculation_history';
  late SharedPreferences _prefs;

  @override
  List<HistoryItem> build() {
    _init();
    return [];
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final savedHistory = _prefs.getStringList(_historyKey);
    if (savedHistory != null) {
      state = savedHistory
          .map((item) => HistoryItem.fromJson(json.decode(item)))
          .toList();
    }
  }

  void addEntry(String title, String result) {
    final newItem = HistoryItem(
      title: title,
      result: result,
      timestamp: DateTime.now(),
    );
    state = [newItem, ...state.take(4)];
    _saveHistory();
  }

  Future<void> _saveHistory() async {
    final encodedHistory =
        state.map((item) => json.encode(item.toJson())).toList();
    await _prefs.setStringList(_historyKey, encodedHistory);
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, List<HistoryItem>>(() {
  return HistoryNotifier();
});

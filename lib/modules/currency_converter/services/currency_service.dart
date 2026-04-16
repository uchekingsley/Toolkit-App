import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _frankfurterUrl = 'https://api.frankfurter.app/';

  Future<Map<String, dynamic>> getLatestRates(String baseCurrency) async {
    try {
      final response = await http.get(Uri.parse('${_frankfurterUrl}latest?from=$baseCurrency'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Map<String, dynamic>.from(data['rates']);
      } else {
        throw Exception('Failed to load rates');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<double>> getRateHistory(String base, String target) async {
    try {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final formatDate = (DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      
      final url = '${_frankfurterUrl}${formatDate(weekAgo)}..${formatDate(now)}?from=$base&to=$target';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        final history = <double>[];
        
        // Extract values in date order
        final sortedDates = rates.keys.toList()..sort();
        for (final date in sortedDates) {
          final rate = rates[date][target];
          if (rate != null) history.add(rate.toDouble());
        }
        return history;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

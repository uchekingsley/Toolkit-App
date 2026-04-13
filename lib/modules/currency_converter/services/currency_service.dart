import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest/';

  Future<Map<String, dynamic>> getLatestRates(String baseCurrency) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$baseCurrency'));
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
}

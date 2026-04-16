import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/currency_service.dart';

class CurrencyState {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double result;
  final Map<String, dynamic> rates;
  final List<double> history;
  final bool isLoading;
  final bool isHistoryLoading;
  final String? error;

  CurrencyState({
    this.fromCurrency = 'USD',
    this.toCurrency = 'EUR',
    this.amount = 1.0,
    this.result = 0.0,
    this.rates = const {},
    this.history = const [],
    this.isLoading = false,
    this.isHistoryLoading = false,
    this.error,
  });

  CurrencyState copyWith({
    String? fromCurrency,
    String? toCurrency,
    double? amount,
    double? result,
    Map<String, dynamic>? rates,
    List<double>? history,
    bool? isLoading,
    bool? isHistoryLoading,
    String? error,
  }) {
    return CurrencyState(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amount: amount ?? this.amount,
      result: result ?? this.result,
      rates: rates ?? this.rates,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
      error: error,
    );
  }
}

class CurrencyNotifier extends Notifier<CurrencyState> {
  static const _fromKey = 'last_from_currency';
  static const _toKey = 'last_to_currency';
  late SharedPreferences _prefs;

  @override
  CurrencyState build() {
    _init();
    return CurrencyState();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final from = _prefs.getString(_fromKey);
    final to = _prefs.getString(_toKey);

    if (from != null || to != null) {
      state = state.copyWith(
        fromCurrency: from ?? state.fromCurrency,
        toCurrency: to ?? state.toCurrency,
      );
    }

    // Asyncs fetch outside of build cycle
    Future.microtask(() {
      fetchRates();
      fetchHistory();
    });
  }

  Future<void> fetchRates() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final rates = await CurrencyService().getLatestRates(state.fromCurrency);
      state = state.copyWith(rates: rates, isLoading: false);
      _calculateResult();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchHistory() async {
    state = state.copyWith(isHistoryLoading: true);
    try {
      final history = await CurrencyService().getRateHistory(
        state.fromCurrency,
        state.toCurrency,
      );
      state = state.copyWith(history: history, isHistoryLoading: false);
    } catch (e) {
      state = state.copyWith(isHistoryLoading: false);
    }
  }

  void updateAmount(double amount) {
    state = state.copyWith(amount: amount);
    _calculateResult();
  }

  void updateFromCurrency(String currency) {
    state = state.copyWith(fromCurrency: currency);
    _prefs.setString(_fromKey, currency);
    fetchRates();
    fetchHistory();
  }

  void updateToCurrency(String currency) {
    state = state.copyWith(toCurrency: currency);
    _prefs.setString(_toKey, currency);
    _calculateResult();
    fetchHistory();
  }

  void swapCurrencies() {
    final from = state.fromCurrency;
    final to = state.toCurrency;
    state = state.copyWith(fromCurrency: to, toCurrency: from);
    _prefs.setString(_fromKey, to);
    _prefs.setString(_toKey, from);
    fetchRates();
    fetchHistory();
  }

  void _calculateResult() {
    if (state.rates.containsKey(state.toCurrency)) {
      final rate = state.rates[state.toCurrency] as num;
      state = state.copyWith(result: state.amount * rate.toDouble());
    }
  }
}

final currencyProvider = NotifierProvider<CurrencyNotifier, CurrencyState>(() {
  return CurrencyNotifier();
});

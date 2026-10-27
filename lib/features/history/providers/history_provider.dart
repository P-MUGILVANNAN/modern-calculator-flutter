import 'package:flutter/material.dart';
import 'package:calcpro/features/history/models/calculation_history_item.dart';
import 'package:calcpro/features/history/services/history_storage.dart';

/// Provider for managing calculation history state.
class HistoryProvider extends ChangeNotifier {
  final HistoryStorage? _storage;
  List<CalculationHistoryItem> _items = [];

  HistoryProvider([this._storage]) {
    _load();
  }

  List<CalculationHistoryItem> get items => List.unmodifiable(_items);
  bool get hasHistory => _items.isNotEmpty;

  void _load() {
    if (_storage != null) {
      _items = _storage.loadHistory();
      notifyListeners();
    }
  }

  Future<void> addHistory(String expression, String result) async {
    if (expression.trim().isEmpty || result.trim().isEmpty) return;

    final item = CalculationHistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
    );

    _items.insert(0, item);
    if (_items.length > 100) {
      _items.removeLast();
    }
    notifyListeners();

    await _storage?.saveItem(item);
  }

  Future<void> deleteItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
    await _storage?.deleteItem(id);
  }

  Future<void> clearAll() async {
    _items.clear();
    notifyListeners();
    await _storage?.clearHistory();
  }
}

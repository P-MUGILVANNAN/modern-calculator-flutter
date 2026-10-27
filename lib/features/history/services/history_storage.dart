import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calcpro/features/history/models/calculation_history_item.dart';

/// Storage service for persisting calculation history via SharedPreferences.
class HistoryStorage {
  static const String _storageKey = 'calcpro_history_v1';
  static const int _maxHistoryItems = 100;

  final SharedPreferences _prefs;

  HistoryStorage(this._prefs);

  /// Factory to initialize HistoryStorage asynchronously.
  static Future<HistoryStorage> init() async {
    final prefs = await SharedPreferences.getInstance();
    return HistoryStorage(prefs);
  }

  /// Loads calculation history ordered by newest first.
  List<CalculationHistoryItem> loadHistory() {
    try {
      final String? rawJson = _prefs.getString(_storageKey);
      if (rawJson == null || rawJson.isEmpty) {
        return [];
      }

      final dynamic decoded = jsonDecode(rawJson);
      if (decoded is List) {
        return decoded
            .map(
              (item) =>
                  CalculationHistoryItem.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Saves a new calculation item to history.
  Future<bool> saveItem(CalculationHistoryItem item) async {
    try {
      final List<CalculationHistoryItem> current = loadHistory();
      // Insert newest at beginning
      current.insert(0, item);
      if (current.length > _maxHistoryItems) {
        current.removeRange(_maxHistoryItems, current.length);
      }

      final String encoded = jsonEncode(
        current.map((e) => e.toJson()).toList(),
      );
      return await _prefs.setString(_storageKey, encoded);
    } catch (_) {
      return false;
    }
  }

  /// Deletes a single item by id.
  Future<bool> deleteItem(String id) async {
    try {
      final List<CalculationHistoryItem> current = loadHistory();
      current.removeWhere((element) => element.id == id);
      final String encoded = jsonEncode(
        current.map((e) => e.toJson()).toList(),
      );
      return await _prefs.setString(_storageKey, encoded);
    } catch (_) {
      return false;
    }
  }

  /// Clears all history entries.
  Future<bool> clearHistory() async {
    try {
      return await _prefs.remove(_storageKey);
    } catch (_) {
      return false;
    }
  }
}

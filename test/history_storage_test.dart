import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calcpro/features/history/models/calculation_history_item.dart';
import 'package:calcpro/features/history/services/history_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HistoryStorage', () {
    late HistoryStorage storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storage = HistoryStorage(prefs);
    });

    test('Loads empty list initially', () {
      final items = storage.loadHistory();
      expect(items, isEmpty);
    });

    test('Saves and loads history items ordered newest first', () async {
      final item1 = CalculationHistoryItem(
        id: '1',
        expression: '2 + 2',
        result: '4',
        timestamp: DateTime(2026, 1, 1, 10, 0),
      );
      final item2 = CalculationHistoryItem(
        id: '2',
        expression: '5 × 5',
        result: '25',
        timestamp: DateTime(2026, 1, 1, 10, 5),
      );

      await storage.saveItem(item1);
      await storage.saveItem(item2);

      final loaded = storage.loadHistory();
      expect(loaded.length, 2);
      expect(loaded.first.id, '2'); // newest first
      expect(loaded.last.id, '1');
      expect(loaded.first.result, '25');
    });

    test('Deletes individual item', () async {
      final item1 = CalculationHistoryItem(
        id: 'item-to-delete',
        expression: '10 ÷ 2',
        result: '5',
        timestamp: DateTime.now(),
      );
      await storage.saveItem(item1);
      expect(storage.loadHistory().length, 1);

      await storage.deleteItem('item-to-delete');
      expect(storage.loadHistory(), isEmpty);
    });

    test('Clears all history', () async {
      for (int i = 0; i < 5; i++) {
        await storage.saveItem(
          CalculationHistoryItem(
            id: '$i',
            expression: '$i + 1',
            result: '${i + 1}',
            timestamp: DateTime.now(),
          ),
        );
      }
      expect(storage.loadHistory().length, 5);

      await storage.clearHistory();
      expect(storage.loadHistory(), isEmpty);
    });
  });
}

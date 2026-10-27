import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calcpro/app.dart';
import 'package:calcpro/features/history/services/history_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent storage
  SharedPreferences? prefs;
  HistoryStorage? historyStorage;
  try {
    prefs = await SharedPreferences.getInstance();
    historyStorage = HistoryStorage(prefs);
  } catch (e) {
    debugPrint('SharedPreferences initialization failed: $e');
  }

  runApp(CalcProApp(prefs: prefs, historyStorage: historyStorage));
}

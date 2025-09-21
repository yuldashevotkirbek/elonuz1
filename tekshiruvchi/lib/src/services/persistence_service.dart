import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_summary.dart';
import '../providers.dart';

final persistenceServiceProvider = Provider<PersistenceService>((ref) {
  final prefs = ref.read(sharedPrefsProvider);
  return PersistenceService(prefs);
});

class PersistenceService {
  final SharedPreferences prefs;
  PersistenceService(this.prefs);

  String _key(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return 'summary_${d.toIso8601String()}';
  }

  Future<void> saveSummary(DailySummary summary) async {
    final jsonStr = jsonEncode(summary.toJson());
    await prefs.setString(_key(summary.date), jsonStr);
  }

  DailySummary? loadSummary(DateTime date) {
    final str = prefs.getString(_key(date));
    if (str == null) return null;
    return DailySummary.fromJson(jsonDecode(str) as Map<String, dynamic>);
  }
}


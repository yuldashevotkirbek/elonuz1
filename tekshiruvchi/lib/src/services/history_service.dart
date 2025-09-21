import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_summary.dart';
import 'persistence_service.dart';

final historyServiceProvider = Provider<HistoryService>((ref) {
  return HistoryService(ref);
});

class HistoryService {
  final Ref ref;
  HistoryService(this.ref);

  List<DailySummary?> loadLastDays(int days) {
    final pers = ref.read(persistenceServiceProvider);
    final now = DateTime.now();
    final List<DailySummary?> result = [];
    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      result.add(pers.loadSummary(date));
    }
    return result;
  }
}


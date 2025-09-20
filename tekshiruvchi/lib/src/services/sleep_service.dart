import 'package:usage_stats/usage_stats.dart';

class SleepSummary {
  final Duration estimatedSleep;
  final DateTime? start;
  final DateTime? end;
  const SleepSummary({this.start, this.end, required this.estimatedSleep});
}

class SleepService {
  // Simple heuristic: sleep window = longest period between screen on events during night 21:00-09:00
  Future<SleepSummary> estimateLastNight() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final lastNightStart = todayStart.subtract(const Duration(hours: 3)); // 21:00 previous day
    final morningEnd = todayStart.add(const Duration(hours: 9)); // 09:00 today
    final events = await UsageStats.queryEvents(lastNightStart, morningEnd);
    DateTime? lastScreenOn;
    DateTime? bestStart;
    DateTime? bestEnd;
    Duration bestGap = Duration.zero;

    for (final e in events) {
      final type = e.eventType;
      final time = DateTime.fromMillisecondsSinceEpoch(int.tryParse(e.timeStamp ?? '0') ?? 0);
      if (type == '1') { // MOVE_TO_FOREGROUND
        if (lastScreenOn != null) {
          final gap = time.difference(lastScreenOn);
          if (gap > bestGap) {
            bestGap = gap;
            bestStart = lastScreenOn;
            bestEnd = time;
          }
        }
        lastScreenOn = time;
      }
    }
    return SleepSummary(start: bestStart, end: bestEnd, estimatedSleep: bestGap);
  }
}


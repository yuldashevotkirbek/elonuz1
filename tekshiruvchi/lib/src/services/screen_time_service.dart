import 'package:flutter/services.dart';
import 'package:usage_stats/usage_stats.dart';

class ScreenTimeSummary {
  final Duration totalForeground;
  final Map<String, Duration> appDurations;

  const ScreenTimeSummary({
    required this.totalForeground,
    required this.appDurations,
  });
}

class ScreenTimeService {
  Future<ScreenTimeSummary> queryToday() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = now;

    try {
      final stats = await UsageStats.queryUsageStats(start, end);
      final Map<String, Duration> perApp = {};
      Duration total = Duration.zero;

      for (final stat in stats) {
        final pkg = stat.packageName ?? 'unknown';
        final millis = int.tryParse(stat.totalTimeInForeground ?? '0') ?? 0;
        final d = Duration(milliseconds: millis);
        total += d;
        perApp[pkg] = (perApp[pkg] ?? Duration.zero) + d;
      }

      return ScreenTimeSummary(totalForeground: total, appDurations: perApp);
    } on PlatformException {
      return const ScreenTimeSummary(totalForeground: Duration.zero, appDurations: {});
    }
  }
}


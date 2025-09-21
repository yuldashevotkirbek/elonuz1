import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_summary.dart';
import '../providers.dart';
import 'persistence_service.dart';

final autoPersistProvider = Provider<AutoPersistService>((ref) {
  return AutoPersistService(ref);
});

class AutoPersistService {
  final Ref ref;
  Timer? _timer;
  AutoPersistService(this.ref);

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 15), (_) => saveNow());
  }

  Future<void> saveNow() async {
    final now = DateTime.now();
    final screen = await ref.read(screenTimeServiceProvider).queryToday();
    final sleep = await ref.read(sleepServiceProvider).estimateLastNight();
    final distance = ref.read(distanceServiceProvider).metersWalked;
    final summary = DailySummary(
      date: now,
      screenTime: screen.totalForeground,
      distanceMeters: distance,
      sleep: sleep.estimatedSleep,
    );
    await ref.read(persistenceServiceProvider).saveSummary(summary);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}


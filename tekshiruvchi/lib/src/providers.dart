import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'permissions/permissions_controller.dart';
import 'services/distance_service.dart';
import 'services/screen_time_service.dart';
import 'services/sleep_service.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

final permissionsProvider = permissionsControllerProvider;

final distanceServiceProvider = Provider<DistanceTrackerService>((ref) => DistanceTrackerService());
final screenTimeServiceProvider = Provider<ScreenTimeService>((ref) => ScreenTimeService());
final sleepServiceProvider = Provider<SleepService>((ref) => SleepService());


import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usage_stats/usage_stats.dart';

final permissionsControllerProvider = Provider<PermissionsController>((ref) {
  return PermissionsController();
});

class PermissionsController {
  Future<bool> ensureLocationPermissions() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }
    // Background location for continuous tracking
    final background = await Permission.locationAlways.request();
    return background.isGranted;
  }

  Future<bool> ensureActivityRecognition() async {
    final status = await Permission.activityRecognition.request();
    return status.isGranted;
  }

  Future<bool> ensureUsageAccess() async {
    try {
      final hasPermission = await UsageStats.checkUsagePermission();
      if (hasPermission == true) return true;
    } on PlatformException {
      // continue to open settings
    }

    final intent = const AndroidIntent(
      action: 'android.settings.USAGE_ACCESS_SETTINGS',
    );
    await intent.launch();
    // Caller should re-check after returning to app
    return false;
  }
}


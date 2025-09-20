import 'dart:async';
import 'package:geolocator/geolocator.dart';

class DistanceTrackerService {
  StreamSubscription<Position>? _subscription;
  Position? _lastPosition;
  double _meters = 0.0;

  double get metersWalked => _meters;

  Future<void> start() async {
    final settings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 5,
    );
    _subscription?.cancel();
    _subscription = Geolocator.getPositionStream(locationSettings: settings).listen((pos) {
      if (_lastPosition != null) {
        _meters += Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          pos.latitude,
          pos.longitude,
        );
      }
      _lastPosition = pos;
    });
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}


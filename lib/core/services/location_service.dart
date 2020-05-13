import 'dart:async';
import 'package:location/location.dart';
import 'package:locationprojectflutter/data/model/models_stream_location/user_location.dart';

class LocationService {
  UserLocation _currentLocation;
  Location _location = Location();
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  LocationService() {
    _location.requestPermission().then((granted) {
      if (granted != null) {
        _location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            ));
          }
        });
      }
    });
  }

  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<UserLocation> getLocation() async {
    try {
      var _userLocation = await _location.getLocation();
      _currentLocation = UserLocation(
        latitude: _userLocation.latitude,
        longitude: _userLocation.longitude,
      );
    } catch (e) {
      print('Could not get the location: $e');
    }
    return _currentLocation;
  }
}

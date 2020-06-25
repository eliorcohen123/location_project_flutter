import 'location.dart';

class Geometry {
  Location location;

  Geometry.fromJson(Map<String, dynamic> json) {
    this.location = Location.fromJson(
      json['location'],
    );
  }
}

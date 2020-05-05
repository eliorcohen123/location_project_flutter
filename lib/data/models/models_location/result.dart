import 'package:locationprojectflutter/data/models/models_location/photo.dart';
import 'geometry.dart';

class Result {
  String id;
  String name;
  String vicinity;
  Geometry geometry;
  List<Photo> photos;

  Result({
    this.id,
    this.name,
    this.vicinity,
    this.geometry,
    this.photos,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'],
      name: json['name'],
      vicinity: json['vicinity'],
      geometry: Geometry.fromJson(json['geometry']),
      photos: json.containsKey("photos")
          ? json['photos'].map<Photo>((i) => Photo.fromJson(i)).toList()
          : [],
    );
  }
}

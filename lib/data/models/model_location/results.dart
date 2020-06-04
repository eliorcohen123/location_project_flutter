import 'package:locationprojectflutter/data/models/model_location/photo.dart';
import 'geometry.dart';

class Results {
  final String id;
  final String name;
  final String vicinity;
  final Geometry geometry;
  final List<Photo> photos;

  Results({
    this.id,
    this.name,
    this.vicinity,
    this.geometry,
    this.photos,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      id: json['id'],
      name: json['name'],
      vicinity: json['vicinity'],
      geometry: Geometry.fromJson(json['geometry']),
      photos: json.containsKey("photos")
          ? json['photos']
              .map<Photo>(
                (i) => Photo.fromJson(i),
              )
              .toList()
          : [],
    );
  }
}

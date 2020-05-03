import 'package:locationprojectflutter/data/models/photo.dart';

import 'geometry.dart';

class Result {
  final Geometry geometry;
  final String id;
  final String name;
  final String vicinity;
  final List<Photo> photos;

  Result({this.geometry, this.id, this.name, this.vicinity, this.photos});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      geometry: Geometry.fromJson(json['geometry']),
      id: json['id'],
      name: json['name'],
      vicinity: json['vicinity'],
      photos: json['photos'] != null
          ? json['photos'].map<Photo>((i) => Photo.fromJson(i)).toList()
          : [],
    );
  }
}

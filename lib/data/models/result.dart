import 'package:locationprojectflutter/data/models/photo.dart';

import 'geometry.dart';

class Result {
  final String id;
  final String name;
  final String vicinity;
  final Geometry geometry;
  final List<Photo> photos;

  Result({
    this.id,
    this.name,
    this.vicinity,
    this.geometry,
    this.photos,
  });

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['vicinity'] = vicinity;
    map['geometry'] = geometry;
    map['photos'] = photos;
    return map;
  }

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'],
      name: json['name'],
      vicinity: json['vicinity'],
      geometry: Geometry.fromJson(json['geometry']),
      photos: json['photos'] != null
          ? json['photos'].map<Photo>((i) => Photo.fromJson(i)).toList()
          : [],
    );
  }
}

import 'package:locationprojectflutter/data/models/photo.dart';

import 'geometry.dart';

class Result {
  String id;
  int _id;
  String name;
  String vicinity;
  Geometry geometry;
  double lat;
  double lng;
  List<Photo> photos;
  String photo;

  Result({
    this.id,
    this.name,
    this.vicinity,
    this.geometry,
    this.photos,
  });

  Result.sqlf(this.name, this.vicinity, this.lat, this.lng, this.photo);

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['_id'] = _id;
    }
    map['name'] = name;
    map['vicinity'] = vicinity;
    map['lat'] = lat;
    map['lng'] = lng;
    map['photo'] = photos;
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

  Result.fromSqlf(Map<String, dynamic> map) {
    this._id = map['_id'];
    this.name = map['name'];
    this.vicinity = map['vicinity'];
    this.lat = map['lat'];
    this.lng = map['lng'];
    this.photo = map['photo'];
  }
}

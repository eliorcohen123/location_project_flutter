import 'package:locationprojectflutter/data/models/model_location/photo.dart';
import 'geometry.dart';

class Results {
  String id;
  String name;
  String vicinity;
  Geometry geometry;
  List<Photo> photos;

  Results.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.vicinity = json['vicinity'];
    this.geometry = Geometry.fromJson(
      json['geometry'],
    );
    this.photos = json.containsKey("photos")
        ? List<Photo>.from(
            json['photos']
                .map<Photo>(
                  (i) => Photo.fromJson(i),
                )
                .toList(),
          )
        : [];
  }
}

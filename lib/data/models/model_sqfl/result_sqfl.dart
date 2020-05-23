import 'package:cloud_firestore/cloud_firestore.dart';

class ResultSqfl {
  int id;
  Timestamp date;
  String name;
  String vicinity;
  double lat;
  double lng;
  String photo;

  ResultSqfl.sqfl(this.name, this.vicinity, this.lat, this.lng, this.photo);

  Map<String, dynamic> toSqfl() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['vicinity'] = vicinity;
    map['lat'] = lat;
    map['lng'] = lng;
    map['photo'] = photo;
    return map;
  }

  ResultSqfl.fromSqfl(Map<String, dynamic> map) {
    this.id = map['id'];
    this.date = map['date'];
    this.name = map['name'];
    this.vicinity = map['vicinity'];
    this.lat = map['lat'];
    this.lng = map['lng'];
    this.photo = map['photo'];
  }
}

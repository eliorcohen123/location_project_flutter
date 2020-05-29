import 'package:cloud_firestore/cloud_firestore.dart';

class ResultsFirestore {
  String idLive;
  int count;
  Timestamp date;
  String name;
  String vicinity;
  double lat;
  double lng;
  String photo;

  ResultsFirestore.fromSqfl(Map<String, dynamic> map) {
    this.idLive = map['idLive'];
    this.count = map['count'];
    this.date = map['date'];
    this.name = map['name'];
    this.vicinity = map['vicinity'];
    this.lat = map['lat'];
    this.lng = map['lng'];
    this.photo = map['photo'];
  }
}

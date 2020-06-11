import 'package:cloud_firestore/cloud_firestore.dart';

class ResultsLiveChat {
  String text;
  String from;
  Timestamp date;

  ResultsLiveChat.fromSqfl(Map<String, dynamic> map) {
    this.text = map['text'];
    this.from = map['from'];
    this.date = map['date'];
  }
}

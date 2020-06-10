import 'package:locationprojectflutter/data/models/model_location/results.dart';

class ResultsLocation {
  List<Results> results;

  ResultsLocation.fromJson(Map<String, dynamic> json) {
    this.results = json['results']
        .map<Results>(
          (i) => Results.fromJson(i),
        )
        .toList();
  }
}

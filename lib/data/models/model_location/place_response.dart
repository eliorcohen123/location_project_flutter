import 'package:locationprojectflutter/data/models/model_location/results.dart';

class PlaceResponse {
  final List<Results> results;

  PlaceResponse({this.results});

  PlaceResponse fromJson(Map<String, dynamic> json) {
    return PlaceResponse(results: parseResults(json['results']));
  }

  static List<Results> parseResults(List<dynamic> list) {
    return list.map((i) => Results.fromJson(i)).toList();
  }
}

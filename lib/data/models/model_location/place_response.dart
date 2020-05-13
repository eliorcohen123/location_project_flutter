import 'package:locationprojectflutter/data/models/model_location/result.dart';

class PlaceResponse {
  final List<Result> results;

  PlaceResponse({this.results});

  PlaceResponse fromJson(Map<String, dynamic> json) {
    return PlaceResponse(results: parseResults(json['results']));
  }

  static List<Result> parseResults(List<dynamic> list) {
    return list.map((i) => Result.fromJson(i)).toList();
  }
}

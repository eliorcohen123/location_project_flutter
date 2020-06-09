import 'package:locationprojectflutter/data/models/model_location/results.dart';

class PlaceResponse {
  static List<Results> parseResults(List<dynamic> list) {
    return list
        .map(
          (i) => Results.fromJson(i),
        )
        .toList();
  }
}

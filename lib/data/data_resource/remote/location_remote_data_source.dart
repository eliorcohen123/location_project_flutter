import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:locationprojectflutter/core/constants/constants.dart';
import 'package:locationprojectflutter/data/models/models_location/error.dart';
import 'package:locationprojectflutter/data/models/models_location/place_response.dart';
import 'package:locationprojectflutter/data/models/models_location/result.dart';

class LocationRemoteDataSource {
  static final LocationRemoteDataSource _singleton = LocationRemoteDataSource._internal();

  factory LocationRemoteDataSource() {
    return _singleton;
  }

  LocationRemoteDataSource._internal();

  Error _error;
  List<Result> _places;
  String _baseUrl = Constants.baseUrl;
  String _API_KEY = Constants.API_KEY;

  responseJsonLocation(double latitude, double longitude, String type,
      int valueRadiusText, String text) async {
    String url =
        '$_baseUrl?key=$_API_KEY&location=$latitude,$longitude&opennow=true&types=$type&radius=$valueRadiusText&keyword=$text';
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _handleResponse(data);
    } else {
      throw Exception('An error occurred getting places nearby');
    }
    return _places;
  }

  _handleResponse(data) {
    if (data['status'] == "REQUEST_DENIED") {
      _error = Error.fromJson(data);
      print(_error);
    } else if (data['status'] == "OK") {
      _places = PlaceResponse.parseResults(data['results']);
    } else {
      print(data);
    }
  }
}

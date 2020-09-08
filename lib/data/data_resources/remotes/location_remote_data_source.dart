import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:locationprojectflutter/core/constants/constants_urls_keys.dart';
import 'package:locationprojectflutter/data/models/model_googleapis/error.dart';
import 'package:locationprojectflutter/data/models/model_googleapis/results.dart';
//import 'package:dio/dio.dart';

class LocationRemoteDataSource {
  static final LocationRemoteDataSource _singleton =
      LocationRemoteDataSource.internal();

  factory LocationRemoteDataSource() => _singleton;

  LocationRemoteDataSource.internal();

  final String _BASE_URL = ConstantsUrlsKeys.BASE_URL_GOOGLE_MAPS;
  final String _API_KEY = ConstantsUrlsKeys.API_KEY_GOOGLE_MAPS;
  Error _error;
  List<Results> _places = [];

//  Dio _dio = Dio();

  Future responseJsonLocation(double latitude, double longitude, String open,
      String type, int valueRadiusText, String text) async {
    String url =
        '$_BASE_URL?key=$_API_KEY&location=$latitude,$longitude$open&types=$type&radius=$valueRadiusText&keyword=$text';
    print(url);
    final response = await http.get(url);
//    final response = await _dio.get(url); // dio
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _handleResponse(data);
//      _handleResponse(response.data); // dio
    } else {
      throw Exception('An error occurred getting places nearby');
    }
    return _places;
  }

  void _handleResponse(data) {
    if (data['status'] == "REQUEST_DENIED") {
      _places = [];
      _error = Error.fromJson(data);
      print(_error.errorMessage);
    } else if (data['status'] == "OK") {
      _places = List<Results>.from(
        data['results']
            .map(
              (i) => Results.fromJson(i),
            )
            .toList(),
      );
    } else {
      _places = [];
      print(data);
    }
  }
}

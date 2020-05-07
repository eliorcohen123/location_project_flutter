import 'package:locationprojectflutter/data/data_resource/remote/location_remote_data_source.dart';

class LocationRepositoryImpl {
  LocationRemoteDataSource locationRemoteDataSource =
      LocationRemoteDataSource();

  getResponseLocation(double latitude, double longitude, String type,
      int valueRadiusText, String text) async {
    return locationRemoteDataSource.responseJsonLocation(
        latitude, longitude, type, valueRadiusText, text);
  }
}

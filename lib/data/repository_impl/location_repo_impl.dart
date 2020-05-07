import 'package:locationprojectflutter/data/data_resource/remote/location_remote_data_source.dart';
import 'package:locationprojectflutter/domain/repositories_api/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRemoteDataSource locationRemoteDataSource =
      LocationRemoteDataSource();

  @override
  Future getLocationJson(double latitude, double longitude, String type,
      int valueRadiusText, String text) {
    return locationRemoteDataSource.responseJsonLocation(
        latitude, longitude, type, valueRadiusText, text);
  }
}

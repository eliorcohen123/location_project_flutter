import 'package:locationprojectflutter/data/data_resources/remotes/location_remote_data_source.dart';
import 'package:locationprojectflutter/domain/repositories_api/location_repo_api.dart';

class LocationRepoImpl implements LocationRepoApi {
  LocationRemoteDataSource _locationRemoteDataSource =
      LocationRemoteDataSource();

  @override
  Future getLocationJson(double latitude, double longitude, String open,
      String type, int valueRadiusText, String text) {
    return _locationRemoteDataSource.responseJsonLocation(
      latitude,
      longitude,
      open,
      type,
      valueRadiusText,
      text,
    );
  }
}

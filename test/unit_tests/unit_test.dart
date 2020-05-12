import 'package:flutter_test/flutter_test.dart';
import 'package:locationprojectflutter/data/model/models_location/result.dart';
import 'package:locationprojectflutter/data/repository_impl/location_repo_impl.dart';

void main() {
  group("Unit tests for app", () {
    test('String should be JSON', () async {
      LocationRepositoryImpl locationRepositoryImpl = LocationRepositoryImpl();
      double latitude = 31.7428444;
      double longitude = 34.9847567;
      String open = '';
      String type = 'bar';
      int valueRadiusText = 50000;
      String text = 'Bar';
      List<Result> searchString = await locationRepositoryImpl.getLocationJson(
          latitude, longitude, open, type, valueRadiusText, text);
      expect(searchString, isNot(null));
      expect(searchString, isNotEmpty);
    });
  });
}

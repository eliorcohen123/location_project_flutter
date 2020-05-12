import 'package:flutter_test/flutter_test.dart';
import 'package:locationprojectflutter/data/repository_impl/location_repo_impl.dart';

void main() {
  group("Unit tests for app", () {
    test('String should be reversed', () async {
      LocationRepositoryImpl locationRepositoryImpl = LocationRepositoryImpl();
      double latitude = 31.7428444;
      double longitude = 34.9847567;
      String open = '';
      String type = 'bar';
      int valueRadiusText = 50000;
      String text = 'Bar';
      String searchString = await locationRepositoryImpl.getLocationJson(
          latitude, longitude, open, type, valueRadiusText, text);
      expect(searchString, '');
    });
  });
}

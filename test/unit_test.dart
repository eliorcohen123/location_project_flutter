import 'package:flutter_test/flutter_test.dart';
import 'package:locationprojectflutter/data/models/model_location/result.dart';
import 'package:locationprojectflutter/data/repositories_impl/location_repo_impl.dart';
import 'package:locationprojectflutter/presentation/utils/validations.dart';

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

    test('Email validation', () async {
      bool valid = Validations().validateEmail('eliorjobcohen@gmail.com');
      expect(valid, true);
    });
  });
}

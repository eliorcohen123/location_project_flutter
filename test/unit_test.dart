import 'package:flutter_test/flutter_test.dart';
import 'package:locationprojectflutter/data/models/model_googleapis/results.dart';
import 'package:locationprojectflutter/data/repositories_impl/location_repo_impl.dart';
import 'package:locationprojectflutter/presentation/utils/validations.dart';

void main() {
  group(
    "Unit tests for app",
    () {
      test(
        'String should be JSON',
        () async {
          LocationRepoImpl locationRepositoryImpl = LocationRepoImpl();
          double latitude = 31.7428444;
          double longitude = 34.9847567;
          String open = '';
          String type = 'bar';
          int valueRadiusText = 50000;
          String text = 'Bar';
          List<Results> searchString =
              await locationRepositoryImpl.getLocationJson(
                  latitude, longitude, open, type, valueRadiusText, text);
          expect(searchString, isNot(null));
          expect(searchString, isNotEmpty);
        },
      );

      test(
        'Email validation',
        () async {
          bool valid = Validations().validateEmail('eliorjobcohen@gmail.com');
          bool invalid = Validations().validateEmail('eliorjobcohengmail.com');
          expect(valid, true);
          expect(invalid, false);
        },
      );

      test(
        'Password validation',
        () async {
          bool valid = Validations().validatePassword('12345678');
          bool invalid = Validations().validatePassword('123456');
          expect(valid, true);
          expect(invalid, false);
        },
      );

      test(
        'Phone validation',
            () async {
          bool valid = Validations().validatePhone('0503332696');
          bool invalid = Validations().validatePassword('0501111');
          expect(valid, true);
          expect(invalid, false);
        },
      );
    },
  );
}

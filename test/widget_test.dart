import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locationprojectflutter/data/repositories_impl/location_repo_impl.dart';
import 'package:locationprojectflutter/presentation/pages/sign_in_firebase.dart';
import 'package:mockito/mockito.dart';

class MockRemoteReverseServiceAPI extends Mock implements LocationRepoImpl {}

void main() {
  group(
    "Widget tests for app",
    () {
      testWidgets(
        'Test Mock',
        (WidgetTester tester) async {
          double latitude = 31.7428444;
          double longitude = 34.9847567;
          String open = '';
          String type = 'bar';
          int valueRadiusText = 50000;
          String text = 'Bar';
          LocationRepoImpl service = MockRemoteReverseServiceAPI();

          expect(
              service.getLocationJson(
                  latitude, longitude, open, type, valueRadiusText, text),
              null);
        },
      );

      testWidgets(
        'Login Page',
        (WidgetTester tester) async {
          MaterialApp app = MaterialApp(
            home: Scaffold(
              body: SignInFirebase(),
            ),
          );
          await tester.pumpWidget(app);

          Finder emailField = find.byKey(
            Key('emailLogin'),
          );
          await tester.enterText(emailField, 'eliorjobcohen@gmail.com');

          Finder passwordField = find.byKey(
            Key('passwordLogin'),
          );
          await tester.enterText(passwordField, '12345678');

          expect(
            find.byType(TextFormField),
            findsNWidgets(2),
          );
          expect(
            find.byType(Text),
            findsNWidgets(6),
          );
          expect(
            find.text('Login'),
            findsNWidgets(2),
          );
          expect(
              find.text(
                  'Don' + "'" + 't Have an account? click here to register'),
              findsOneWidget);
        },
      );
    },
  );
}

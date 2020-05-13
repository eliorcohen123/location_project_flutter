// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locationprojectflutter/data/repositories_impl/location_repo_impl.dart';
import 'package:locationprojectflutter/presentation/pages/signin_email_firebase.dart';

import 'mock_api.dart';

void main() {
  group("Widget tests for app", () {
    testWidgets('Test Mock', (WidgetTester tester) async {
      double latitude = 31.7428444;
      double longitude = 34.9847567;
      String open = '';
      String type = 'bar';
      int valueRadiusText = 50000;
      String text = 'Bar';
      LocationRepositoryImpl service = MockRemoteReverseServiceAPI();

      expect(
          service.getLocationJson(
              latitude, longitude, open, type, valueRadiusText, text),
          null);
    });

    testWidgets('Login Page', (WidgetTester tester) async {
      MaterialApp app = MaterialApp(
        home: Scaffold(body: LoginPage()),
      );
      await tester.pumpWidget(app);

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(Text), findsNWidgets(6));
      expect(find.text('Login'), findsNWidgets(2));
      expect(
          find.text('Don' + "'" + 't Have an account? click here to register'),
          findsOneWidget);
    });
  });
}

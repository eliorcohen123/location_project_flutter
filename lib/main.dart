import 'package:flutter/material.dart';
import 'package:locationprojectflutter/core/services/location_service.dart';
import 'package:locationprojectflutter/presentation/pages/sign_in_firebase.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/results_sqfl_provider.dart';
import 'package:provider/provider.dart';
import 'package:locationprojectflutter/data/models/model_stream_location/user_location.dart';
//import 'package:locationprojectflutter/core/services/service_locator.dart';

void main() {
//  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserLocation>(
          create: (context) => LocationService().locationStream,
        ),
        ChangeNotifierProvider<ResultsSqflProvider>(
          create: (context) => ResultsSqflProvider(),
        ),
      ],
      child: MaterialApp(
        home: SigninFirebase(),
      ),
    );
  }
}

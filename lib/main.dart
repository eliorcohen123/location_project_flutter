import 'package:flutter/material.dart';
import 'package:locationprojectflutter/core/services/location_service.dart';
import 'package:locationprojectflutter/presentation/pages/signin_email_firebase.dart';
import 'package:provider/provider.dart';
import 'package:locationprojectflutter/data/model/models_stream_location/user_location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
        create: (context) => LocationService().locationStream,
        child: MaterialApp(home: LoginPage()));
  }
}

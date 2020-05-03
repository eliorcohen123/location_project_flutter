import 'package:flutter/material.dart';
import 'package:locationprojectflutter/presentation/pages/list_map_activity.dart';
import 'package:locationprojectflutter/core/services/location_service.dart';
import 'package:provider/provider.dart';
import 'data/models/user_location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
        create: (context) => LocationService().locationStream,
        child: MaterialApp(home: ListMapActivity()));
  }
}

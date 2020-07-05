import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMapListProvider extends ChangeNotifier {
  List<Marker> _markers = <Marker>[];

  List<Marker> get markersGet => _markers;

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMapListProvider extends ChangeNotifier {
  List<Marker> _markers = <Marker>[];
  bool _checkingBottomSheet = false;

  List<Marker> get markersGet => _markers;

  bool get checkingBottomSheetGet => _checkingBottomSheet;

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }

  void isCheckingBottomSheet(bool checkingBottomSheet) {
    _checkingBottomSheet = checkingBottomSheet;
    notifyListeners();
  }
}

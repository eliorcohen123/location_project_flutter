import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProviderCustomMapList extends ChangeNotifier {
  List<Marker> _markers = <Marker>[];
  bool _isCheckingBottomSheet = false;

  List<Marker> get markersGet => _markers;

  bool get isCheckingBottomSheetGet => _isCheckingBottomSheet;

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }

  void isCheckingBottomSheet(bool isCheckingBottomSheet) {
    _isCheckingBottomSheet = isCheckingBottomSheet;
    notifyListeners();
  }
}

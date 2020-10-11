import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:locationprojectflutter/core/constants/constants_urls_keys.dart';
import 'package:locationprojectflutter/data/models/model_live_favorites/results_live_favorites.dart';
import 'package:locationprojectflutter/data/models/model_stream_location/user_location.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_add_edit_favorite_places.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ProviderLiveFavoritePlaces extends ChangeNotifier {
  final String _API_KEY = ConstantsUrlsKeys.API_KEY_GOOGLE_MAPS;
  final Stream<QuerySnapshot> _snapshots =
      Firestore.instance.collection('places').snapshots();
  List<ResultsFirestore> _places = [];
  bool _isCheckingBottomSheet = false;
  StreamSubscription<QuerySnapshot> _placeSub;
  UserLocation _userLocation;

  String get API_KEYGet => _API_KEY;

  List<ResultsFirestore> get placesGet => _places;

  bool get isCheckingBottomSheetGet => _isCheckingBottomSheet;

  StreamSubscription<QuerySnapshot> get placeSubGet => _placeSub;

  UserLocation get userLocationGet => _userLocation;

  void lPlaces(List<ResultsFirestore> places) {
    _places = places;
    notifyListeners();
  }

  void isCheckingBottomSheet(bool isCheckingBottomSheet) {
    _isCheckingBottomSheet = isCheckingBottomSheet;
    notifyListeners();
  }

  void userLocation(BuildContext context) {
    _userLocation = Provider.of<UserLocation>(context);
  }

  void newTaskModalBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            isCheckingBottomSheet(false);

            Navigator.pop(context, false);

            return Future.value(false);
          },
          child: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Container(
                child: ListView(
                  children: [
                    WidgetAddEditFavoritePlaces(
                      nameList: placesGet[index].name,
                      addressList: placesGet[index].vicinity,
                      latList: placesGet[index].lat,
                      lngList: placesGet[index].lng,
                      photoList: placesGet[index].photo.isNotEmpty
                          ? placesGet[index].photo
                          : "",
                      edit: false,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void readFirebase() {
    _placeSub?.cancel();
    _placeSub = _snapshots.listen(
      (QuerySnapshot snapshot) {
        final List<ResultsFirestore> places = snapshot.documents
            .map(
              (documentSnapshot) =>
                  ResultsFirestore.fromSqfl(documentSnapshot.data),
            )
            .toList();

        places.sort(
          (a, b) {
            return b.count.compareTo(a.count);
          },
        );

        lPlaces(places);
      },
    );
  }

  String calculateDistance(double _meter) {
    String _myMeters;
    if (_meter < 1000.0) {
      _myMeters = 'Meters: ' + (_meter.round()).toString();
    } else {
      _myMeters =
          'KM: ' + (_meter.round() / 1000.0).toStringAsFixed(2).toString();
    }
    return _myMeters;
  }

  void shareContent(String name, String vicinity, double lat, double lng,
      String photo, BuildContext context) {
    final RenderBox box = context.findRenderObject();
    Share.share(
        'Name: $name' +
            '\n' +
            'Vicinity: $vicinity' +
            '\n' +
            'Latitude: $lat' +
            '\n' +
            'Longitude: $lng' +
            '\n' +
            'Photo: $photo',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:locationprojectflutter/data/models/model_live_chat/results_live_chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderLiveChat extends ChangeNotifier {
  final Stream<QuerySnapshot> _snapshots = Firestore.instance
      .collection('liveMessages')
      .orderBy('date', descending: true)
      .limit(50)
      .snapshots();
  final TextEditingController _messageController = TextEditingController();
  final Firestore _firestore = Firestore.instance;
  SharedPreferences _sharedPrefs;
  List<ResultsLiveChat> _places = [];
  StreamSubscription<QuerySnapshot> _placeSub;
  String _valueUserEmail;

  TextEditingController get messageControllerGet => _messageController;

  SharedPreferences get sharedGet => _sharedPrefs;

  List<ResultsLiveChat> get placesGet => _places;

  StreamSubscription<QuerySnapshot> get placeSubGet => _placeSub;

  String get valueUserEmailGet => _valueUserEmail;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void lPlaces(List<ResultsLiveChat> places) {
    _places = places;
    notifyListeners();
  }

  void initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        sharedPref(prefs);
        _valueUserEmail = sharedGet.getString('userEmail') ?? 'guest@gmail.com';
      },
    );
  }

  void callback() async {
    if (_messageController.text.length > 0) {
      await _firestore.collection("liveMessages").add(
        {
          'text': _messageController.text,
          'from': _valueUserEmail,
          'date': DateTime.now(),
        },
      ).then(
        (value) => _messageController.text = '',
      );
    }
  }

  void readFirebase() {
    _placeSub?.cancel();
    _placeSub = _snapshots.listen(
      (QuerySnapshot snapshot) {
        final List<ResultsLiveChat> places = snapshot.documents
            .map(
              (documentSnapshot) =>
                  ResultsLiveChat.fromSqfl(documentSnapshot.data),
            )
            .toList();

        lPlaces(places);
      },
    );
  }
}

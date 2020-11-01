import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderLiveChat extends ChangeNotifier {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SharedPreferences _sharedPrefs;
  String _valueUserEmail;
  List<DocumentSnapshot> _listMessage;

  TextEditingController get messageControllerGet => _messageController;

  SharedPreferences get sharedGet => _sharedPrefs;

  String get valueUserEmailGet => _valueUserEmail;

  FirebaseFirestore get firestoreGet => _firestore;

  List<DocumentSnapshot> get listMessageGet => _listMessage;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void listMessage(List<DocumentSnapshot> listMessage) {
    _listMessage = listMessage;
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
}

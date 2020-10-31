import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderHomeChat extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  SharedPreferences _sharedPrefs;
  String _valueIdUser;
  List<DocumentSnapshot> _listMessage;

  FirebaseFirestore get firestoreGet => _firestore;

  SharedPreferences get sharedGet => _sharedPrefs;

  String get valueIdUserGet => _valueIdUser;

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
        _valueIdUser = sharedGet.getString('userIdEmail');
      },
    ).then(
      (value) => {
        _getNotifications(),
      },
    );
  }

  void _getNotifications() {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage: $message');
        kIsWeb
            ? print('onMessage(Web): $message')
            : Platform.isAndroid
                ? _showNotifications(message['notification'])
                : _showNotifications(message['aps']['alert']);
        return;
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume: $message');
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch: $message');
        return;
      },
    );

    _firebaseMessaging.getToken().then(
      (token) {
        print('token: $token');
        _firestore.collection('users').doc(_valueIdUser).update(
          {
            'pushToken': token,
          },
        );
      },
    ).catchError(
      (err) {
        Fluttertoast.showToast(msg: err.message.toString());
      },
    );
  }

  void initNotifications() {
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = const IOSInitializationSettings();
    var initSettings = InitializationSettings(android, iOS);
    _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void _showNotifications(message) async {
    var android = AndroidNotificationDetails(
      'com.eliorcohen.locationprojectflutter',
      'Lovely Favorite Places',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);

    print(message);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message['title'].toString(),
      message['body'].toString(),
      platform,
      payload: json.encode(message),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_home_chat.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:locationprojectflutter/core/constants/constants_colors.dart';

class PageHomeChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderHomeChat>(
      builder: (context, results, child) {
        return PageHomeChatProv();
      },
    );
  }
}

class PageHomeChatProv extends StatefulWidget {
  @override
  _PageHomeChatProvState createState() => _PageHomeChatProvState();
}

class _PageHomeChatProvState extends State<PageHomeChatProv> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String _valueIdUser;
  var _listMessage;
  ProviderHomeChat _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ProviderHomeChat>(context, listen: false);

    _initGetSharedPrefs();
    _initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _listViewData(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.settings),
          color: ConstantsColors.LIGHT_BLUE,
          onPressed: () => ShowerPages.pushPageChatSettings(context),
        ),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.navigate_before,
          color: ConstantsColors.LIGHT_BLUE,
          size: 40,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _listViewData() {
    return Container(
      child: Center(
        child: StreamBuilder(
          stream: _firestore
              .collection('users')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ConstantsColors.ORANGE,
                  ),
                ),
              );
            } else {
              _listMessage = snapshot.data.documents;
              return _listMessage.length == 0
                  ? const Text(
                      'No Users',
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 30,
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(
                          ResponsiveScreen().widthMediaQuery(context, 10)),
                      itemBuilder: (context, index) =>
                          _buildItem(context, _listMessage[index]),
                      itemCount: _listMessage.length,
                    );
            }
          },
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == _valueIdUser) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth:
                                ResponsiveScreen().widthMediaQuery(context, 1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ConstantsColors.ORANGE,
                            ),
                          ),
                          width:
                              ResponsiveScreen().widthMediaQuery(context, 50),
                          height:
                              ResponsiveScreen().widthMediaQuery(context, 50),
                          padding: EdgeInsets.all(
                              ResponsiveScreen().widthMediaQuery(context, 15)),
                        ),
                        imageUrl: document['photoUrl'],
                        width: ResponsiveScreen().widthMediaQuery(context, 50),
                        height: ResponsiveScreen().widthMediaQuery(context, 50),
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: ConstantsColors.DARK_GRAY,
                      ),
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Nickname: ${document['nickname'] ?? 'Not available'}',
                          style: TextStyle(color: ConstantsColors.DARK_BLUE),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(
                          ResponsiveScreen().widthMediaQuery(context, 10),
                          ResponsiveScreen().heightMediaQuery(context, 0),
                          ResponsiveScreen().widthMediaQuery(context, 0),
                          ResponsiveScreen().heightMediaQuery(context, 5),
                        ),
                      ),
                      Container(
                        child: Text(
                          'About Me: ${document['aboutMe'] ?? 'Not available'}',
                          style: TextStyle(color: ConstantsColors.DARK_BLUE),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(
                          ResponsiveScreen().widthMediaQuery(context, 10),
                          ResponsiveScreen().heightMediaQuery(context, 0),
                          ResponsiveScreen().widthMediaQuery(context, 0),
                          ResponsiveScreen().heightMediaQuery(context, 5),
                        ),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(
                      left: ResponsiveScreen().widthMediaQuery(context, 20)),
                ),
              ),
            ],
          ),
          onPressed: () {
            ShowerPages.pushPageChatScreen(
              context,
              document.documentID,
              document['photoUrl'],
            );
          },
          color: ConstantsColors.LIGHT_GRAY,
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveScreen().heightMediaQuery(context, 10),
            horizontal: ResponsiveScreen().widthMediaQuery(context, 25),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        margin: EdgeInsets.only(
          bottom: ResponsiveScreen().heightMediaQuery(context, 10),
          left: ResponsiveScreen().widthMediaQuery(context, 5),
          right: ResponsiveScreen().widthMediaQuery(context, 5),
        ),
      );
    }
  }

  void _initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        _provider.sharedPref(prefs);
        _valueIdUser = _provider.sharedGet.getString('userIdEmail');
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
        _firestore.collection('users').document(_valueIdUser).updateData(
          {
            'pushToken': token,
          },
        );
      },
    ).catchError(
      (err) {
        Fluttertoast.showToast(
          msg: err.message.toString(),
        );
      },
    );
  }

  void _initNotifications() {
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

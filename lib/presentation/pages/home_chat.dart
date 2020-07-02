import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locationprojectflutter/presentation/pages/chat_screen.dart';
import 'package:locationprojectflutter/presentation/pages/settings_chat.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/home_chat_provider.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeChatProvider>(
      builder: (context, results, child) {
        return HomeChatProv();
      },
    );
  }
}

class HomeChatProv extends StatefulWidget {
  HomeChatProv({Key key}) : super(key: key);

  @override
  _HomeChatProvState createState() => _HomeChatProvState();
}

class _HomeChatProvState extends State<HomeChatProv> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isLoading = false;
  String _valueIdUser;
  var _listMessage, _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<HomeChatProvider>(context, listen: false);

    _initGetSharedPrefs();
    _initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Lovely Favorite Places',
          style: TextStyle(color: Color(0xFFE9FFFF)),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFFE9FFFF),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            color: Color(0xFFE9FFFF),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsChat(),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Center(
              child: StreamBuilder(
                stream: _firestore.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xfff5a623),
                        ),
                      ),
                    );
                  } else {
                    _listMessage = snapshot.data.documents;
                    return _listMessage.length == 0
                        ? Text(
                            'No Uers',
                            style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 30,
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(10.0),
                            itemBuilder: (context, index) =>
                                _buildItem(context, _listMessage[index]),
                            itemCount: _listMessage.length,
                          );
                  }
                },
              ),
            ),
          ),
          Positioned(
            child: _isLoading ? const CircularProgressIndicator() : Container(),
          )
        ],
      ),
      drawer: DrawerTotal(),
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
                            strokeWidth: 1.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xfff5a623),
                            ),
                          ),
                          width:
                              ResponsiveScreen().widthMediaQuery(context, 50),
                          height:
                              ResponsiveScreen().heightMediaQuery(context, 50),
                          padding: EdgeInsets.all(15.0),
                        ),
                        imageUrl: document['photoUrl'],
                        width: ResponsiveScreen().widthMediaQuery(context, 50),
                        height:
                            ResponsiveScreen().heightMediaQuery(context, 50),
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: Color(0xffaeaeae),
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
                          'Nickname: ${document['nickname']}',
                          style: TextStyle(color: Color(0xff203152)),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'About me: ${document['aboutMe'] ?? 'Not available'}',
                          style: TextStyle(color: Color(0xff203152)),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  peerId: document.documentID,
                  peerAvatar: document['photoUrl'],
                ),
              ),
            );
          },
          color: Color(0xffE8E8E8),
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
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
        Platform.isAndroid
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
    var initializationSettingsAndroid =
        AndroidInitializationSettings('assets/icon.png');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotifications(message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.eliorcohen.locationprojectflutter'
          : 'com.eliorcohen.locationprojectflutter',
      'Lovely Favorite Places',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message['title'].toString(),
      message['body'].toString(),
      platformChannelSpecifics,
      payload: json.encode(message),
    );
  }
}

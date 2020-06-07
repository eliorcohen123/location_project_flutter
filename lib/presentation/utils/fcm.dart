import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushMessaging extends StatefulWidget {
  @override
  _PushMessagingState createState() => _PushMessagingState();
}

class _PushMessagingState extends State<PushMessaging> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    _initNotificationPermissions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  void _initNotificationPermissions() {
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
    _firebaseMessaging.onIosSettingsRegistered.listen(
      (IosNotificationSettings settings) {
        print("Settings registered: $settings");
      },
    );
  }
}

import 'package:flutter/material.dart';

class VideoCallProvider extends ChangeNotifier {
  List<int> _users = <int>[];
  List<String> _infoStrings = <String>[];
  bool _muted = false;

  List<int> get isUsersGet => _users;

  List<String> get isInfoStringsGet => _infoStrings;

  bool get isMutedGet => _muted;

  void isUsersAdd(int users) {
    _users.add(users);
    notifyListeners();
  }

  void isUsersRemove(int users) {
    _users.remove(users);
    notifyListeners();
  }

  void isUsersClear() {
    _users.clear();
    notifyListeners();
  }

  void isInfoStringsAdd(String infoStrings) {
    _infoStrings.add(infoStrings);
    notifyListeners();
  }

  void isInfoStringsClear() {
    _infoStrings.clear();
    notifyListeners();
  }

  void isMuted(bool muted) {
    _muted = muted;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class ProviderVideoCall extends ChangeNotifier {
  List<int> _users = [];
  List<String> _infoStrings = [];
  bool _isMuted = false;

  List<int> get isUsersGet => _users;

  List<String> get isInfoStringsGet => _infoStrings;

  bool get isMutedGet => _isMuted;

  void usersAdd(int users) {
    _users.add(users);
    notifyListeners();
  }

  void usersRemove(int users) {
    _users.remove(users);
    notifyListeners();
  }

  void usersClear() {
    _users.clear();
    notifyListeners();
  }

  void infoStringsAdd(String infoStrings) {
    _infoStrings.add(infoStrings);
    notifyListeners();
  }

  void infoStringsClear() {
    _infoStrings.clear();
    notifyListeners();
  }

  void isMuted(bool isMuted) {
    _isMuted = isMuted;
    notifyListeners();
  }
}

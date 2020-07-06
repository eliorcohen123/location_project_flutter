import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsChatProvider extends ChangeNotifier {
  bool _loading = false;
  String _nickname = '', _aboutMe = '', _photoUrl = '';
  File _avatarImageFile;
  SharedPreferences _sharedPrefs;

  SharedPreferences get sharedGet => _sharedPrefs;

  bool get loadingGet => _loading;

  String get nicknameGet => _nickname;

  String get aboutMeGet => _aboutMe;

  String get photoUrlGet => _photoUrl;

  File get avatarImageFileGet => _avatarImageFile;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void aboutMe(String aboutMe) {
    _aboutMe = aboutMe;
    notifyListeners();
  }

  void nickname(String nickname) {
    _nickname = nickname;
    notifyListeners();
  }

  void photoUrl(String photoUrl) {
    _photoUrl = photoUrl;
    notifyListeners();
  }

  void avatarImageFile(File avatarImageFile) {
    _avatarImageFile = avatarImageFile;
    notifyListeners();
  }
}

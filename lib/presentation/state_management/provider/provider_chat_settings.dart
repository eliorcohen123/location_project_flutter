import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderSettingsChat extends ChangeNotifier {
  bool _isLoading = false;
  String _nickname = '', _aboutMe = '', _photoUrl = '';
  File _avatarImageFile;
  SharedPreferences _sharedPrefs;

  bool get isLoadingGet => _isLoading;

  String get nicknameGet => _nickname;

  String get aboutMeGet => _aboutMe;

  String get photoUrlGet => _photoUrl;

  File get avatarImageFileGet => _avatarImageFile;

  SharedPreferences get sharedGet => _sharedPrefs;

  void isLoading(bool isLoading) {
    _isLoading = isLoading;
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

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }
}

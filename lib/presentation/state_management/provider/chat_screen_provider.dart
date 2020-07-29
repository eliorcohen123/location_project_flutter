import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart' as rec;

class ChatScreenProvider extends ChangeNotifier {
  bool _isLoading = false, _isShowSticker = false;
  rec.Recording _current;
  rec.RecordingStatus _currentStatus = rec.RecordingStatus.Initialized;
  SharedPreferences _sharedPrefs;

  bool get isLoadingGet => _isLoading;

  bool get isShowStickerGet => _isShowSticker;

  rec.Recording get isCurrentGet => _current;

  rec.RecordingStatus get isCurrentStatusGet => _currentStatus;

  SharedPreferences get sharedPrefsGet => _sharedPrefs;

  void isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void isShowSticker(bool isShowSticker) {
    _isShowSticker = isShowSticker;
    notifyListeners();
  }

  void isRecording(rec.Recording current) {
    _current = current;
    notifyListeners();
  }

  void isRecordingStatus(rec.RecordingStatus currentStatus) {
    _currentStatus = currentStatus;
    notifyListeners();
  }

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }
}

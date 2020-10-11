import 'dart:async';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:locationprojectflutter/presentation/utils/utils_app.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart' as rec;
import 'package:file/local.dart';

class ProviderChatScreen extends ChangeNotifier {
  final Firestore _firestore = Firestore.instance;
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  final LocalFileSystem localFileSystem = LocalFileSystem();
  FocusNode _focusNode = FocusNode();
  bool _isLoading = false, _isShowSticker = false;
  rec.Recording _current;
  rec.RecordingStatus _currentStatus = rec.RecordingStatus.Initialized;
  SharedPreferences _sharedPrefs;
  rec.FlutterAudioRecorder _recorder;
  String _groupChatId = '', _imageVideoAudioUrl = '', _id;
  List<DocumentSnapshot> _listMessage;
  File _imageVideoAudioFile;

  Firestore get firestoreGet => _firestore;

  TextEditingController get textEditingControllerGet => _textEditingController;

  ScrollController get listScrollControllerGet => _listScrollController;

  FocusNode get focusNodeGet => _focusNode;

  rec.RecordingStatus get isCurrentStatusGet => _currentStatus;

  SharedPreferences get sharedPrefsGet => _sharedPrefs;

  bool get isLoadingGet => _isLoading;

  bool get isShowStickerGet => _isShowSticker;

  rec.Recording get isCurrentGet => _current;

  String get groupChatIdGet => _groupChatId;

  String get idGet => _id;

  List<DocumentSnapshot> get listMessageGet => _listMessage;

  void focusNode(FocusNode focusNode) {
    _focusNode = focusNode;
    notifyListeners();
  }

  void isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void isShowSticker(bool isShowSticker) {
    _isShowSticker = isShowSticker;
    notifyListeners();
  }

  void currentRecording(rec.Recording current) {
    _current = current;
    notifyListeners();
  }

  void recordingStatus(rec.RecordingStatus currentStatus) {
    _currentStatus = currentStatus;
    notifyListeners();
  }

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void listMessage(List<DocumentSnapshot> listMessage) {
    _listMessage = listMessage;
  }

  Future _showDialog(int type, BuildContext context, String peerId) {
    return showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            isLoading(false);

            Navigator.pop(context, false);

            return Future.value(false);
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  type == 1
                      ? "Would you want to send this image?"
                      : type == 3
                          ? "Would you want to send this video?"
                          : type == 4
                              ? "Would you want to send this audio?"
                              : '',
                  textAlign: TextAlign.center,
                ),
                UtilsApp.dividerHeight(context, 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: ResponsiveScreen().heightMediaQuery(context, 40),
                      width: ResponsiveScreen().widthMediaQuery(context, 100),
                      child: RaisedButton(
                        highlightElevation: 0.0,
                        splashColor: Colors.deepPurpleAccent,
                        highlightColor: Colors.deepPurpleAccent,
                        elevation: 0.0,
                        color: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () {
                          isLoading(false);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    UtilsApp.dividerWidth(context, 20),
                    Container(
                      height: ResponsiveScreen().heightMediaQuery(context, 40),
                      width: ResponsiveScreen().widthMediaQuery(context, 100),
                      child: RaisedButton(
                        highlightElevation: 0.0,
                        splashColor: Colors.deepPurpleAccent,
                        highlightColor: Colors.deepPurpleAccent,
                        elevation: 0.0,
                        color: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () {
                          _uploadFile(type, peerId);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void newTaskModalBottomSheet(BuildContext context, int type, String peerId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            Navigator.pop(context, false);

            return Future.value(false);
          },
          child: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Container(
                child: Wrap(
                  children: [
                    ListTile(
                      title: Center(
                        child: type == 1
                            ? const Text('Take A Picture')
                            : const Text('Take A Video'),
                      ),
                      onTap: () => _getImageVideo(type, true, context, peerId),
                    ),
                    ListTile(
                      title: Center(
                        child: type == 1
                            ? const Text('Open A Picture Gallery')
                            : const Text('Open A Video Gallery'),
                      ),
                      onTap: () => _getImageVideo(type, false, context, peerId),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void initGetSharedPrefs(String peerId) {
    SharedPreferences.getInstance().then(
      (prefs) {
        sharedPref(prefs);
        _id = sharedPrefsGet.getString('id') ?? '';
        if (_id.hashCode <= peerId.hashCode) {
          _groupChatId = '$_id-$peerId';
        } else {
          _groupChatId = '$peerId-$_id';
        }
      },
    ).then(
      (value) => _readLocal(peerId),
    );
  }

  void _readLocal(String peerId) async {
    await _firestore.collection('users').document(_id).updateData(
      {
        'chattingWith': peerId,
      },
    ).then(
      (value) => print(peerId),
    );
  }

  void _getImageVideo(
      int type, bool take, BuildContext context, String peerId) async {
    if (type == 1) {
      if (take) {
        _imageVideoAudioFile =
            await ImagePicker.pickImage(source: ImageSource.camera);
      } else {
        _imageVideoAudioFile =
            await ImagePicker.pickImage(source: ImageSource.gallery);
      }
    } else if (type == 3) {
      if (take) {
        _imageVideoAudioFile =
            await ImagePicker.pickVideo(source: ImageSource.camera);
      } else {
        _imageVideoAudioFile =
            await ImagePicker.pickVideo(source: ImageSource.gallery);
      }
    }

    if (_imageVideoAudioFile != null) {
      Navigator.pop(context, false);

      isLoading(true);

      _showDialog(type, context, peerId);
    }
  }

  void onFocusChange() {
    if (_focusNode.hasFocus) {
      isShowSticker(false);
    }
  }

  void getSticker() {
    _focusNode.unfocus();

    isShowSticker(!isShowStickerGet);
  }

  void _uploadFile(int type, String peerId) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask;
    if (type == 1) {
      uploadTask = reference.putFile(
        _imageVideoAudioFile,
      );
    } else if (type == 3) {
      uploadTask = reference.putFile(
        _imageVideoAudioFile,
        StorageMetadata(contentType: 'video/mp4'),
      );
    } else if (type == 4) {
      uploadTask = reference.putFile(
        _imageVideoAudioFile,
        StorageMetadata(contentType: 'audio/mp3'),
      );
    }
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then(
      (downloadUrl) {
        _imageVideoAudioUrl = downloadUrl;

        isLoading(false);
        onSendMessage(_imageVideoAudioUrl, type, peerId);
      },
      onError: (err) {
        isLoading(false);
        Fluttertoast.showToast(msg: err.toString());
      },
    );
  }

  void onSendMessage(String content, int type, String peerId) {
    if (content.trim() != '') {
      _textEditingController.clear();

      DocumentReference documentReference = _firestore
          .collection('messages')
          .document(_groupChatId)
          .collection(_groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      _firestore.runTransaction(
        (transaction) async {
          await transaction.set(
            documentReference,
            {
              'idFrom': _id,
              'idTo': peerId,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': content,
              'type': type,
            },
          );
        },
      );
      _listScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            _listMessage != null &&
            _listMessage[index - 1]['idFrom'] == _id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            _listMessage != null &&
            _listMessage[index - 1]['idFrom'] != _id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  String idVideo(String peerId) {
    List<String> _strList = [];
    _strList.add(_id);
    _strList.add(peerId);
    _strList.sort((a, b) => a.compareTo(b));
    String _strId = _strList[0] + _strList[1];
    return _strId;
  }

  void videoSendMessage(String peerId, BuildContext context) {
    ShowerPages.pushPageVideoCall(
      context,
      idVideo(peerId),
      ClientRole.Broadcaster,
    );
  }

  void initRecord(BuildContext context) async {
    try {
      if (await rec.FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        Directory appDocDirectory;
        if (kIsWeb) {
          print('Web');
        } else {
          if (Platform.isIOS) {
            appDocDirectory = await getApplicationDocumentsDirectory();
          } else {
            appDocDirectory = await getExternalStorageDirectory();
          }
        }

        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        _recorder = rec.FlutterAudioRecorder(customPath,
            audioFormat: rec.AudioFormat.WAV);

        await _recorder.initialized;
        var current = await _recorder.current(channel: 0);
        currentRecording(current);
        recordingStatus(current.status);
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: const Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  void startRecord() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      currentRecording(recording);

      const tick = const Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (isCurrentStatusGet == rec.RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        currentRecording(current);
        recordingStatus(isCurrentGet.status);
      });
    } catch (e) {
      print(e);
    }
  }

  void stopRecord(BuildContext context, String peerId) async {
    var result = await _recorder.stop();
    _imageVideoAudioFile = localFileSystem.file(result.path);

    currentRecording(result);
    recordingStatus(isCurrentGet.status);

    if (_imageVideoAudioFile != null) {
      isLoading(true);

      _showDialog(4, context, peerId);
    }

    initRecord(context);
  }

  void handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}

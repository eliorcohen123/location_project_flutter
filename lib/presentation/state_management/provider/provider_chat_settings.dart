import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';

class ProviderSettingsChat extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FocusNode _focusNodeNickname = FocusNode();
  final FocusNode _focusNodeAboutMe = FocusNode();
  bool _isLoading = false;
  String _nickname = '', _aboutMe = '', _photoUrl = '';
  File _avatarImageFile;
  SharedPreferences _sharedPrefs;
  DocumentReference _document;
  TextEditingController _controllerNickname, _controllerAboutMe;
  String _id = '';

  FocusNode get focusNodeNicknameGet => _focusNodeNickname;

  FocusNode get focusNodeAboutMeGet => _focusNodeAboutMe;

  bool get isLoadingGet => _isLoading;

  String get nicknameGet => _nickname;

  String get aboutMeGet => _aboutMe;

  String get photoUrlGet => _photoUrl;

  File get avatarImageFileGet => _avatarImageFile;

  SharedPreferences get sharedGet => _sharedPrefs;

  TextEditingController get controllerNicknameGet => _controllerNickname;

  TextEditingController get controllerAboutMeGet => _controllerAboutMe;

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

  void newTaskModalBottomSheet(BuildContext context) {
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
                        child: const Text('Take A Picture'),
                      ),
                      onTap: () => _getImage(true, context),
                    ),
                    ListTile(
                      title: const Center(
                        child: Text('Open A Gallery'),
                      ),
                      onTap: () => _getImage(false, context),
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

  void initControllerTextEditing() async {
    SharedPreferences.getInstance().then(
      (prefs) {
        sharedPref(prefs);
        _id = sharedGet.getString('id') ?? '';
        nickname(sharedGet.getString('nickname') ?? '');
        aboutMe(sharedGet.getString('aboutMe') ?? '');
        photoUrl(sharedGet.getString('photoUrl') ?? '');
      },
    ).then(
      (value) => {
        _document = _firestore.collection('users').doc(_id),
        _document.get().then(
          (document) {
            if (document.exists) {
              nickname(document.data()['nickname']);
              aboutMe(document.data()['aboutMe']);
              photoUrl(document.data()['photoUrl']);
            }
          },
        ).then((value) => {
              _controllerNickname = TextEditingController(text: nicknameGet),
              _controllerAboutMe = TextEditingController(text: aboutMeGet),
            }),
      },
    );
  }

  void _getImage(bool take, BuildContext context) async {
    File image;
    if (take) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    if (image != null) {
      image = await ShowerPages.pushPageSimpleImageCrop(context, image);

      avatarImageFile(image);
      isLoading(true);

      Navigator.pop(context, false);

      _uploadFile();
    }
  }

  void _uploadFile() async {
    StorageReference reference = FirebaseStorage.instance.ref().child(_id);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFileGet);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then(
      (value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then(
            (downloadUrl) {
              photoUrl(downloadUrl);
              _firestore.collection('users').doc(_id).update(
                {
                  'nickname': nicknameGet,
                  'aboutMe': aboutMeGet,
                  'photoUrl': photoUrlGet,
                },
              ).then(
                (data) {
                  isLoading(false);

                  Fluttertoast.showToast(msg: "Upload success");
                },
              ).catchError(
                (err) {
                  isLoading(false);

                  Fluttertoast.showToast(msg: err.toString());
                },
              );
            },
            onError: (err) {
              isLoading(false);

              Fluttertoast.showToast(msg: 'This file is not an image');
            },
          );
        } else {
          isLoading(false);

          Fluttertoast.showToast(msg: 'This file is not an image');
        }
      },
      onError: (err) {
        isLoading(false);

        Fluttertoast.showToast(msg: err.toString());
      },
    );
  }

  void handleUpdateData() {
    _focusNodeNickname.unfocus();
    _focusNodeAboutMe.unfocus();

    isLoading(true);

    _firestore.collection('users').doc(_id).update(
      {
        'nickname': nicknameGet,
        'aboutMe': aboutMeGet,
        'photoUrl': photoUrlGet,
      },
    ).then(
      (data) {
        isLoading(false);

        Fluttertoast.showToast(msg: "Update Success");
      },
    ).catchError(
      (err) {
        isLoading(false);

        Fluttertoast.showToast(msg: err.toString());
      },
    );
  }
}

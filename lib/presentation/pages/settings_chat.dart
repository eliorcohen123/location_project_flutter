import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/appbar_totar.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsChat extends StatefulWidget {
  @override
  State createState() => SettingsChatState();
}

class SettingsChatState extends State<SettingsChat> {
  final Firestore _firestore = Firestore.instance;
  TextEditingController _controllerNickname, _controllerAboutMe;
  SharedPreferences _sharedPrefs;
  String _id = '', _nickname = '', _aboutMe = '', _photoUrl = '';
  bool _isLoading = false;
  File _avatarImageFile;
  final FocusNode _focusNodeNickname = FocusNode();
  final FocusNode _focusNodeAboutMe = FocusNode();
  var document;

  @override
  void initState() {
    super.initState();

    _initControllerTextEditing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTotal(),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        (_avatarImageFile == null)
                            ? (_photoUrl != ''
                                ? Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: _photoUrl != null
                                            ? CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xfff5a623),
                                                ),
                                              )
                                            : Container(),
                                        width: ResponsiveScreen()
                                            .widthMediaQuery(context, 90),
                                        height: ResponsiveScreen()
                                            .heightMediaQuery(context, 50),
                                        padding: EdgeInsets.all(20.0),
                                      ),
                                      imageUrl:
                                          _photoUrl != null ? _photoUrl : '',
                                      width: ResponsiveScreen()
                                          .widthMediaQuery(context, 90),
                                      height: ResponsiveScreen()
                                          .heightMediaQuery(context, 90),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(45.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  )
                                : Icon(
                                    Icons.account_circle,
                                    size: 90.0,
                                    color: Color(0xffaeaeae),
                                  ))
                            : Material(
                                child: Image.file(
                                  _avatarImageFile,
                                  width: 90.0,
                                  height: 90.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(45.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Color(0xff203152).withOpacity(0.5),
                          ),
                          onPressed: _getImage,
                          padding: EdgeInsets.all(30.0),
                          splashColor: Colors.transparent,
                          highlightColor: Color(0xff203152),
                          iconSize: 30.0,
                        ),
                      ],
                    ),
                  ),
                  width: double.infinity,
                  margin: EdgeInsets.all(20.0),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Nickname',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff203152),
                        ),
                      ),
                      margin:
                          EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                    ),
                    Container(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Color(0xff203152),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cool Man',
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(
                              color: Color(0xffaeaeae),
                            ),
                          ),
                          controller: _controllerNickname,
                          onChanged: (value) {
                            _nickname = value;
                          },
                          focusNode: _focusNodeNickname,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                    Container(
                      child: Text(
                        'About me',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff203152),
                        ),
                      ),
                      margin:
                          EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                    ),
                    Container(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Color(0xff203152),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Fun, like travel and play PES...',
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(
                              color: Color(0xffaeaeae),
                            ),
                          ),
                          controller: _controllerAboutMe,
                          onChanged: (value) {
                            _aboutMe = value;
                          },
                          focusNode: _focusNodeAboutMe,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Container(
                  child: FlatButton(
                    onPressed: _handleUpdateData,
                    child: Text(
                      'UPDATE',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    color: Color(0xff203152),
                    highlightColor: Color(0xff8d93a0),
                    splashColor: Colors.transparent,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  ),
                  margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
                ),
              ],
            ),
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
          ),
          Positioned(
            child: _isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xfff5a623),
                        ),
                      ),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                : Container(),
          ),
        ],
      ),
      drawer: DrawerTotal(),
    );
  }

  void _initControllerTextEditing() async {
    SharedPreferences.getInstance().then(
      (prefs) {
        setState(() => _sharedPrefs = prefs);
        _id = _sharedPrefs.getString('id') ?? '';
        _nickname = _sharedPrefs.getString('nickname') ?? '';
        _aboutMe = _sharedPrefs.getString('aboutMe') ?? '';
        _photoUrl = _sharedPrefs.getString('photoUrl') ?? '';
      },
    ).then((value) => {
          document = _firestore.collection('users').document(_id),
          document.get().then(
            (document) {
              if (document.exists) {
                setState(() {
                  _nickname = document['nickname'];
                  _aboutMe = document['aboutMe'];
                  _photoUrl = document['photoUrl'];
                });
              }
            },
          ).then((value) => {
                _controllerNickname = TextEditingController(text: _nickname),
                _controllerAboutMe = TextEditingController(text: _aboutMe),
              }),
        });
  }

  void _getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _avatarImageFile = image;
        _isLoading = true;
      });
    }
    _uploadFile();
  }

  void _uploadFile() async {
    String fileName = _id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(_avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then(
      (value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then(
            (downloadUrl) {
              _photoUrl = downloadUrl;
              _firestore.collection('users').document(_id).updateData(
                {
                  'nickname': _nickname,
                  'aboutMe': _aboutMe,
                  'photoUrl': _photoUrl,
                },
              ).then(
                (data) {
                  setState(() {
                    _isLoading = false;
                  });

                  Fluttertoast.showToast(
                    msg: "Upload success",
                  );
                },
              ).catchError(
                (err) {
                  setState(() {
                    _isLoading = false;
                  });

                  Fluttertoast.showToast(
                    msg: err.toString(),
                  );
                },
              );
            },
            onError: (err) {
              setState(() {
                _isLoading = false;
              });

              Fluttertoast.showToast(
                msg: 'This file is not an image',
              );
            },
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
            msg: 'This file is not an image',
          );
        }
      },
      onError: (err) {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: err.toString(),
        );
      },
    );
  }

  void _handleUpdateData() {
    _focusNodeNickname.unfocus();
    _focusNodeAboutMe.unfocus();

    setState(() {
      _isLoading = true;
    });

    _firestore.collection('users').document(_id).updateData(
      {
        'nickname': _nickname,
        'aboutMe': _aboutMe,
        'photoUrl': _photoUrl,
      },
    ).then(
      (data) {
        setState(() {
          _isLoading = false;
        });

        Fluttertoast.showToast(
          msg: "Update success",
        );
      },
    ).catchError(
      (err) {
        setState(() {
          _isLoading = false;
        });

        Fluttertoast.showToast(
          msg: err.toString(),
        );
      },
    );
  }
}

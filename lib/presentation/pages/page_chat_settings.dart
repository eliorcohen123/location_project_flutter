import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_chat_settings.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_app_bar_total.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:locationprojectflutter/core/constants/constants_colors.dart';

class PageChatSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderSettingsChat>(
      builder: (context, results, child) {
        return PageChatSettingsProv();
      },
    );
  }
}

class PageChatSettingsProv extends StatefulWidget {
  @override
  _PageChatSettingsProvState createState() => _PageChatSettingsProvState();
}

class _PageChatSettingsProvState extends State<PageChatSettingsProv> {
  final Firestore _firestore = Firestore.instance;
  final FocusNode _focusNodeNickname = FocusNode();
  final FocusNode _focusNodeAboutMe = FocusNode();
  var document;
  TextEditingController _controllerNickname, _controllerAboutMe;
  String _id = '';
  ProviderSettingsChat _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ProviderSettingsChat>(context, listen: false);

    _initControllerTextEditing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppBarTotal(),
      body: Stack(
        children: <Widget>[
          _mainBody(),
          _loading(),
        ],
      ),
    );
  }

  Widget _mainBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _circleAvatar(),
          _textFieldsData(),
          _buttonUpdate(),
        ],
      ),
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveScreen().widthMediaQuery(context, 15)),
    );
  }

  Widget _circleAvatar() {
    return Container(
      child: Center(
        child: Stack(
          children: <Widget>[
            _provider.avatarImageFileGet == null
                ? _provider.photoUrlGet != null
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ConstantsColors.ORANGE,
                              ),
                            ),
                            width:
                                ResponsiveScreen().widthMediaQuery(context, 90),
                            height: ResponsiveScreen()
                                .heightMediaQuery(context, 50),
                            padding: const EdgeInsets.all(20.0),
                          ),
                          imageUrl: _provider.photoUrlGet != null
                              ? _provider.photoUrlGet
                              : '',
                          width: 90,
                          height: 90,
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
                        color: ConstantsColors.DARK_GRAY,
                      )
                : Material(
                    child: Image.file(
                      _provider.avatarImageFileGet,
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
                color: ConstantsColors.DARK_BLUE.withOpacity(0.5),
              ),
              onPressed: () => _newTaskModalBottomSheet(context),
              padding: const EdgeInsets.all(30.0),
              splashColor: Colors.transparent,
              highlightColor: ConstantsColors.DARK_BLUE,
              iconSize: 30.0,
            ),
          ],
        ),
      ),
      width: double.infinity,
      margin: const EdgeInsets.all(20.0),
    );
  }

  Widget _textFieldsData() {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            'Nickname',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: ConstantsColors.DARK_BLUE,
            ),
          ),
          margin: EdgeInsets.only(
            left: ResponsiveScreen().widthMediaQuery(context, 10),
            bottom: ResponsiveScreen().heightMediaQuery(context, 5),
            top: ResponsiveScreen().heightMediaQuery(context, 10),
          ),
        ),
        Container(
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: ConstantsColors.DARK_BLUE,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cool Man',
                contentPadding: const EdgeInsets.all(5.0),
                hintStyle: TextStyle(color: ConstantsColors.DARK_GRAY),
              ),
              controller: _controllerNickname,
              onChanged: (value) {
                _provider.nickname(value);
              },
              focusNode: _focusNodeNickname,
            ),
          ),
          margin: EdgeInsets.symmetric(
              horizontal: ResponsiveScreen().widthMediaQuery(context, 30)),
        ),
        Container(
          child: Text(
            'About Me',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: ConstantsColors.DARK_BLUE,
            ),
          ),
          margin: EdgeInsets.only(
            left: ResponsiveScreen().widthMediaQuery(context, 10),
            top: ResponsiveScreen().heightMediaQuery(context, 30),
            bottom: ResponsiveScreen().heightMediaQuery(context, 5),
          ),
        ),
        Container(
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: ConstantsColors.DARK_BLUE,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Fun, like travel and play PES...',
                contentPadding: const EdgeInsets.all(5.0),
                hintStyle: TextStyle(color: ConstantsColors.DARK_GRAY),
              ),
              controller: _controllerAboutMe,
              onChanged: (value) {
                _provider.aboutMe(value);
              },
              focusNode: _focusNodeAboutMe,
            ),
          ),
          margin: EdgeInsets.symmetric(
              horizontal: ResponsiveScreen().widthMediaQuery(context, 30)),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _buttonUpdate() {
    return Container(
      child: FlatButton(
        onPressed: _handleUpdateData,
        child: const Text(
          'UPDATE',
          style: TextStyle(fontSize: 16.0),
        ),
        color: ConstantsColors.DARK_BLUE,
        highlightColor: ConstantsColors.GRAY2,
        splashColor: Colors.transparent,
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveScreen().widthMediaQuery(context, 30),
          vertical: ResponsiveScreen().heightMediaQuery(context, 10),
        ),
      ),
      margin: EdgeInsets.symmetric(
          vertical: ResponsiveScreen().heightMediaQuery(context, 50)),
    );
  }

  Widget _loading() {
    return Positioned(
      child: _provider.isLoadingGet
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ConstantsColors.ORANGE,
                  ),
                ),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  void _initControllerTextEditing() async {
    SharedPreferences.getInstance().then(
      (prefs) {
        _provider.sharedPref(prefs);
        _id = _provider.sharedGet.getString('id') ?? '';
        _provider.nickname(_provider.sharedGet.getString('nickname') ?? '');
        _provider.aboutMe(_provider.sharedGet.getString('aboutMe') ?? '');
        _provider.photoUrl(_provider.sharedGet.getString('photoUrl') ?? '');
      },
    ).then(
      (value) => {
        document = _firestore.collection('users').document(_id),
        document.get().then(
          (document) {
            if (document.exists) {
              _provider.nickname(document['nickname']);
              _provider.aboutMe(document['aboutMe']);
              _provider.photoUrl(document['photoUrl']);
            }
          },
        ).then((value) => {
              _controllerNickname =
                  TextEditingController(text: _provider.nicknameGet),
              _controllerAboutMe =
                  TextEditingController(text: _provider.aboutMeGet),
            }),
      },
    );
  }

  void _getImage(bool take) async {
    File image;
    if (take) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    if (image != null) {
      image = await ShowerPages.pushPageSimpleImageCrop(context, image);

      _provider.avatarImageFile(image);
      _provider.isLoading(true);

      Navigator.pop(context, false);

      _uploadFile();
    }
  }

  void _uploadFile() async {
    StorageReference reference = FirebaseStorage.instance.ref().child(_id);
    StorageUploadTask uploadTask =
        reference.putFile(_provider.avatarImageFileGet);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then(
      (value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then(
            (downloadUrl) {
              _provider.photoUrl(downloadUrl);
              _firestore.collection('users').document(_id).updateData(
                {
                  'nickname': _provider.nicknameGet,
                  'aboutMe': _provider.aboutMeGet,
                  'photoUrl': _provider.photoUrlGet,
                },
              ).then(
                (data) {
                  _provider.isLoading(false);

                  Fluttertoast.showToast(
                    msg: "Upload success",
                  );
                },
              ).catchError(
                (err) {
                  _provider.isLoading(false);

                  Fluttertoast.showToast(
                    msg: err.toString(),
                  );
                },
              );
            },
            onError: (err) {
              _provider.isLoading(false);

              Fluttertoast.showToast(
                msg: 'This file is not an image',
              );
            },
          );
        } else {
          _provider.isLoading(false);

          Fluttertoast.showToast(
            msg: 'This file is not an image',
          );
        }
      },
      onError: (err) {
        _provider.isLoading(false);

        Fluttertoast.showToast(
          msg: err.toString(),
        );
      },
    );
  }

  void _handleUpdateData() {
    _focusNodeNickname.unfocus();
    _focusNodeAboutMe.unfocus();

    _provider.isLoading(true);

    _firestore.collection('users').document(_id).updateData(
      {
        'nickname': _provider.nicknameGet,
        'aboutMe': _provider.aboutMeGet,
        'photoUrl': _provider.photoUrlGet,
      },
    ).then(
      (data) {
        _provider.isLoading(false);

        Fluttertoast.showToast(
          msg: "Update Success",
        );
      },
    ).catchError(
      (err) {
        _provider.isLoading(false);

        Fluttertoast.showToast(
          msg: err.toString(),
        );
      },
    );
  }

  void _newTaskModalBottomSheet(BuildContext context) {
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
                      onTap: () => _getImage(true),
                    ),
                    ListTile(
                      title: const Center(
                        child: Text('Open A Gallery'),
                      ),
                      onTap: () => _getImage(false),
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
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file/local.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart' as rec;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:locationprojectflutter/core/constants/constants_images.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_chat_screen.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:locationprojectflutter/presentation/utils/utils_app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_audio.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:locationprojectflutter/core/constants/constants_colors.dart';

class PageChatScreen extends StatelessWidget {
  final String peerId, peerAvatar;

  const PageChatScreen({Key key, this.peerId, this.peerAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderChatScreen>(
      builder: (context, results, child) {
        return PageChatScreenProv(
          peerId: peerId,
          peerAvatar: peerAvatar,
        );
      },
    );
  }
}

class PageChatScreenProv extends StatefulWidget {
  final String peerId, peerAvatar;

  const PageChatScreenProv({Key key, this.peerId, this.peerAvatar})
      : super(key: key);

  @override
  _PageChatScreenProvState createState() => _PageChatScreenProvState();
}

class _PageChatScreenProvState extends State<PageChatScreenProv> {
  final Firestore _firestore = Firestore.instance;
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  final LocalFileSystem localFileSystem = LocalFileSystem();
  final FocusNode _focusNode = FocusNode();
  rec.FlutterAudioRecorder _recorder;
  String _groupChatId = '', _imageVideoAudioUrl = '', _id;
  var _listMessage;
  File _imageVideoAudioFile;
  ProviderChatScreen _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<ProviderChatScreen>(context, listen: false);
      _provider.isShowSticker(false);
      _provider.recordingStatus(rec.RecordingStatus.Initialized);
    });

    _focusNode.addListener(_onFocusChange);

    _initGetSharedPrefs();
    _initRecord();
  }

  @override
  Widget build(BuildContext context) {
    _handleCameraAndMic();
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: <Widget>[
          _mainBody(),
          _loading(),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.video_call),
          color: ConstantsColors.LIGHT_BLUE,
          onPressed: () => {
            _onSendMessage(_idVideo(), 5),
            ShowerPages.pushPageVideoCall(
              context,
              _idVideo(),
              ClientRole.Broadcaster,
            ),
          },
        ),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.navigate_before,
          color: ConstantsColors.LIGHT_BLUE,
          size: 40,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _mainBody() {
    return Column(
      children: <Widget>[
        _buildMessagesList(),
        _provider.isShowStickerGet ? _buildStickers() : Container(),
        _buildInput(),
      ],
    );
  }

  Widget _buildMessagesList() {
    return Flexible(
      child: _groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  ConstantsColors.ORANGE,
                ),
              ),
            )
          : StreamBuilder(
              stream: _firestore
                  .collection('messages')
                  .document(_groupChatId)
                  .collection(_groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(30)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ConstantsColors.ORANGE,
                      ),
                    ),
                  );
                } else {
                  _listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        _buildItem(index, _listMessage[index]),
                    itemCount: _listMessage.length,
                    reverse: true,
                    controller: _listScrollController,
                  );
                }
              },
            ),
    );
  }

  Widget _buildStickers() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _stickers('mimi1', ConstantsImages.MIMI1),
              _stickers('mimi2', ConstantsImages.MIMI2),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              _stickers('mimi3', ConstantsImages.MIMI3),
              _stickers('mimi4', ConstantsImages.MIMI4),
              _stickers('mimi5', ConstantsImages.MIMI5),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: ConstantsColors.LIGHT_GRAY,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(5.0),
      height: ResponsiveScreen().heightMediaQuery(context, 180),
    );
  }

  Widget _stickers(String name, String asset) {
    return FlatButton(
      onPressed: () => _onSendMessage(name, 2),
      child: Image.asset(
        asset,
        width: ResponsiveScreen().widthMediaQuery(context, 50),
        height: ResponsiveScreen().heightMediaQuery(context, 50),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          _iconInput(
            const Icon(Icons.camera_alt),
            () => _newTaskModalBottomSheet(context, 1),
          ),
          _iconInput(
            const Icon(Icons.video_library),
            () => _newTaskModalBottomSheet(context, 3),
          ),
          _iconInput(
            const Icon(Icons.face),
            () => _getSticker(),
          ),
          _iconInput(
            _provider.isCurrentStatusGet == rec.RecordingStatus.Initialized
                ? const Icon(Icons.mic_none)
                : const Icon(
                    Icons.mic,
                    color: Colors.red,
                  ),
            () =>
                _provider.isCurrentStatusGet == rec.RecordingStatus.Initialized
                    ? _startRecord()
                    : _stopRecord(),
          ),
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(
                  color: ConstantsColors.DARK_BLUE,
                  fontSize: 15.0,
                ),
                controller: _textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: ConstantsColors.DARK_GRAY),
                ),
                focusNode: _focusNode,
              ),
            ),
          ),
          _iconInput(
            const Icon(Icons.send),
            () => _onSendMessage(_textEditingController.text, 0),
          ),
        ],
      ),
      width: double.infinity,
      height: ResponsiveScreen().heightMediaQuery(context, 50),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: ConstantsColors.LIGHT_GRAY,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
    );
  }

  Widget _iconInput(Widget icon, VoidCallback onTap) {
    return Material(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1.0),
        child: IconButton(
          icon: icon,
          onPressed: onTap,
          color: ConstantsColors.DARK_BLUE,
        ),
      ),
      color: Colors.white,
    );
  }

  Widget _buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == _id) {
      return Row(
        children: <Widget>[
          document['type'] == 0
              ? Container(
                  child: Text(
                    document['content'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveScreen().heightMediaQuery(context, 10),
                    horizontal: ResponsiveScreen().widthMediaQuery(context, 15),
                  ),
                  width: ResponsiveScreen().widthMediaQuery(context, 200),
                  decoration: BoxDecoration(
                    color: ConstantsColors.DARK_BLUE,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.only(
                    bottom: _isLastMessageRight(index)
                        ? ResponsiveScreen().heightMediaQuery(context, 20)
                        : ResponsiveScreen().heightMediaQuery(context, 10),
                    right: ResponsiveScreen().widthMediaQuery(context, 10),
                  ),
                )
              : document['type'] == 1
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  ConstantsColors.ORANGE,
                                ),
                              ),
                              width: ResponsiveScreen()
                                  .widthMediaQuery(context, 200),
                              height: ResponsiveScreen()
                                  .heightMediaQuery(context, 200),
                              padding: const EdgeInsets.all(70.0),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                ConstantsImages.IMG_NOT_AVAILABLE,
                                width: ResponsiveScreen()
                                    .widthMediaQuery(context, 200),
                                height: ResponsiveScreen()
                                    .heightMediaQuery(context, 200),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document['content'],
                            width: ResponsiveScreen()
                                .widthMediaQuery(context, 200),
                            height: ResponsiveScreen()
                                .heightMediaQuery(context, 200),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          ShowerPages.pushPageFullPhoto(
                            context,
                            document['content'],
                          );
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                        bottom: _isLastMessageRight(index)
                            ? ResponsiveScreen().heightMediaQuery(context, 20)
                            : ResponsiveScreen().heightMediaQuery(context, 10),
                        right: ResponsiveScreen().widthMediaQuery(context, 10),
                      ),
                    )
                  : document['type'] == 2
                      ? Container(
                          child: Image.asset(
                            'assets/${document['content']}.gif',
                            width: ResponsiveScreen()
                                .widthMediaQuery(context, 100),
                            height: ResponsiveScreen()
                                .heightMediaQuery(context, 100),
                            fit: BoxFit.cover,
                          ),
                          margin: EdgeInsets.only(
                            bottom: _isLastMessageRight(index)
                                ? ResponsiveScreen()
                                    .heightMediaQuery(context, 20)
                                : ResponsiveScreen()
                                    .heightMediaQuery(context, 10),
                            right:
                                ResponsiveScreen().widthMediaQuery(context, 10),
                          ),
                        )
                      : document['type'] == 3
                          ? Container(
                              child: WidgetVideo(
                                url: document['content'],
                              ),
                              margin: EdgeInsets.only(
                                bottom: _isLastMessageRight(index)
                                    ? ResponsiveScreen()
                                        .heightMediaQuery(context, 20)
                                    : ResponsiveScreen()
                                        .heightMediaQuery(context, 10),
                                right: ResponsiveScreen()
                                    .widthMediaQuery(context, 10),
                              ),
                            )
                          : document['type'] == 4
                              ? Container(
                                  width: ResponsiveScreen()
                                      .widthMediaQuery(context, 300),
                                  height: ResponsiveScreen()
                                      .heightMediaQuery(context, 120),
                                  child: WidgetAudio(
                                    url: document['content'],
                                  ),
                                )
                              : document['type'] == 5
                                  ? GestureDetector(
                                      onTap: () => _videoSendMessage(),
                                      child: Container(
                                        child: Text(
                                          'Join video call',
                                          style: TextStyle(
                                              color: Colors.lightBlue),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: ResponsiveScreen()
                                              .heightMediaQuery(context, 10),
                                          horizontal: ResponsiveScreen()
                                              .widthMediaQuery(context, 15),
                                        ),
                                        width: ResponsiveScreen()
                                            .widthMediaQuery(context, 200),
                                        decoration: BoxDecoration(
                                          color: ConstantsColors.DARK_BLUE,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        margin: EdgeInsets.only(
                                          bottom: _isLastMessageRight(index)
                                              ? ResponsiveScreen()
                                                  .heightMediaQuery(context, 20)
                                              : ResponsiveScreen()
                                                  .heightMediaQuery(
                                                      context, 10),
                                          right: ResponsiveScreen()
                                              .widthMediaQuery(context, 10),
                                        ),
                                      ),
                                    )
                                  : Container(),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                _isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ConstantsColors.ORANGE,
                              ),
                            ),
                            width:
                                ResponsiveScreen().widthMediaQuery(context, 35),
                            height: ResponsiveScreen()
                                .heightMediaQuery(context, 35),
                            padding: const EdgeInsets.all(10.0),
                          ),
                          imageUrl: widget.peerAvatar != null
                              ? widget.peerAvatar
                              : '',
                          width:
                              ResponsiveScreen().widthMediaQuery(context, 35),
                          height:
                              ResponsiveScreen().heightMediaQuery(context, 35),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(
                        width: ResponsiveScreen().widthMediaQuery(context, 35),
                      ),
                document['type'] == 0
                    ? Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(color: ConstantsColors.DARK_BLUE),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical:
                              ResponsiveScreen().heightMediaQuery(context, 10),
                          horizontal:
                              ResponsiveScreen().widthMediaQuery(context, 15),
                        ),
                        width: ResponsiveScreen().widthMediaQuery(context, 200),
                        decoration: BoxDecoration(
                          color: ConstantsColors.LIGHT_GRAY,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        margin: EdgeInsets.only(
                            left: ResponsiveScreen()
                                .widthMediaQuery(context, 10)),
                      )
                    : document['type'] == 1
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        ConstantsColors.ORANGE,
                                      ),
                                    ),
                                    width: ResponsiveScreen()
                                        .widthMediaQuery(context, 200),
                                    height: ResponsiveScreen()
                                        .heightMediaQuery(context, 200),
                                    padding: const EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: ConstantsColors.LIGHT_GRAY,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset(
                                      ConstantsImages.IMG_NOT_AVAILABLE,
                                      width: ResponsiveScreen()
                                          .widthMediaQuery(context, 200),
                                      height: ResponsiveScreen()
                                          .heightMediaQuery(context, 200),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document['content'] != null
                                      ? document['content']
                                      : '',
                                  width: ResponsiveScreen()
                                      .widthMediaQuery(context, 200),
                                  height: ResponsiveScreen()
                                      .heightMediaQuery(context, 200),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                ShowerPages.pushPageFullPhoto(
                                  context,
                                  document['content'],
                                );
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(
                                left: ResponsiveScreen()
                                    .widthMediaQuery(context, 10)),
                            decoration: BoxDecoration(
                              color: ConstantsColors.LIGHT_GRAY,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          )
                        : document['type'] == 2
                            ? Container(
                                child: Image.asset(
                                  'assets/${document['content']}.gif',
                                  width: ResponsiveScreen()
                                      .widthMediaQuery(context, 100),
                                  height: ResponsiveScreen()
                                      .heightMediaQuery(context, 100),
                                  fit: BoxFit.cover,
                                ),
                                margin: EdgeInsets.only(
                                    left: ResponsiveScreen()
                                        .widthMediaQuery(context, 10)),
                              )
                            : document['type'] == 3
                                ? Container(
                                    width: ResponsiveScreen()
                                        .widthMediaQuery(context, 200),
                                    height: ResponsiveScreen()
                                        .heightMediaQuery(context, 200),
                                    key: PageStorageKey(
                                      "keydata$index",
                                    ),
                                    child: WidgetVideo(
                                      url: document['content'],
                                    ),
                                    decoration: BoxDecoration(
                                      color: ConstantsColors.LIGHT_GRAY,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  )
                                : document['type'] == 4
                                    ? Container(
                                        width: ResponsiveScreen()
                                            .widthMediaQuery(context, 300),
                                        height: ResponsiveScreen()
                                            .heightMediaQuery(context, 105),
                                        child: WidgetAudio(
                                          url: document['content'],
                                        ),
                                        decoration: BoxDecoration(
                                          color: ConstantsColors.LIGHT_GRAY,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      )
                                    : document['type'] == 5
                                        ? GestureDetector(
                                            onTap: () => _videoSendMessage(),
                                            child: Container(
                                              child: const Text(
                                                'Join video call',
                                                style: TextStyle(
                                                    color: Colors.lightBlue),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: ResponsiveScreen()
                                                    .heightMediaQuery(
                                                        context, 10),
                                                horizontal: ResponsiveScreen()
                                                    .widthMediaQuery(
                                                        context, 15),
                                              ),
                                              width: ResponsiveScreen()
                                                  .widthMediaQuery(
                                                      context, 200),
                                              decoration: BoxDecoration(
                                                color:
                                                    ConstantsColors.LIGHT_GRAY,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              margin: EdgeInsets.only(
                                                  left: ResponsiveScreen()
                                                      .widthMediaQuery(
                                                          context, 10)),
                                            ),
                                          )
                                        : Container(),
              ],
            ),
            _isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(
                            document['timestamp'],
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: ConstantsColors.DARK_GRAY,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      left: ResponsiveScreen().widthMediaQuery(context, 50),
                      top: ResponsiveScreen().heightMediaQuery(context, 5),
                      bottom: ResponsiveScreen().widthMediaQuery(context, 5),
                    ),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(
            bottom: ResponsiveScreen().heightMediaQuery(context, 10)),
      );
    }
  }

  Widget _loading() {
    return _provider.isLoadingGet
        ? Center(
            child: Container(
              decoration: BoxDecoration(
                color: ConstantsColors.DARK_GRAY2,
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : Container();
  }

  void _initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        _provider.sharedPref(prefs);
        _id = _provider.sharedPrefsGet.getString('id') ?? '';
        if (_id.hashCode <= widget.peerId.hashCode) {
          _groupChatId = '$_id-${widget.peerId}';
        } else {
          _groupChatId = '${widget.peerId}-$_id';
        }
      },
    ).then(
      (value) => _readLocal(),
    );
  }

  void _readLocal() async {
    await _firestore.collection('users').document(_id).updateData(
      {
        'chattingWith': widget.peerId,
      },
    ).then(
      (value) => print(widget.peerId),
    );
  }

  void _getImageVideo(int type, bool take) async {
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

      _provider.isLoading(true);

      _showDialog(type);
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _provider.isShowSticker(false);
    }
  }

  void _getSticker() {
    _focusNode.unfocus();

    _provider.isShowSticker(!_provider.isShowStickerGet);
  }

  void _uploadFile(int type) async {
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

        _provider.isLoading(false);
        _onSendMessage(_imageVideoAudioUrl, type);
      },
      onError: (err) {
        _provider.isLoading(false);
        Fluttertoast.showToast(
          msg: err.toString(),
        );
      },
    );
  }

  void _onSendMessage(String content, int type) {
    if (content.trim() != '') {
      _textEditingController.clear();

      var documentReference = _firestore
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
              'idTo': widget.peerId,
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
      Fluttertoast.showToast(
        msg: 'Nothing to send',
      );
    }
  }

  bool _isLastMessageLeft(int index) {
    if ((index > 0 &&
            _listMessage != null &&
            _listMessage[index - 1]['idFrom'] == _id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool _isLastMessageRight(int index) {
    if ((index > 0 &&
            _listMessage != null &&
            _listMessage[index - 1]['idFrom'] != _id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  String _idVideo() {
    List<String> _strList = [];
    _strList.add(_id);
    _strList.add(widget.peerId);
    _strList.sort((a, b) => a.compareTo(b));
    String _strId = _strList[0] + _strList[1];
    return _strId;
  }

  void _videoSendMessage() {
    ShowerPages.pushPageVideoCall(
      context,
      _idVideo(),
      ClientRole.Broadcaster,
    );
  }

  Future _showDialog(int type) {
    return showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            _provider.isLoading(false);

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
                          _provider.isLoading(false);
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
                          _uploadFile(type);
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

  void _newTaskModalBottomSheet(BuildContext context, int type) {
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
                      onTap: () => _getImageVideo(type, true),
                    ),
                    ListTile(
                      title: Center(
                        child: type == 1
                            ? const Text('Open A Picture Gallery')
                            : const Text('Open A Video Gallery'),
                      ),
                      onTap: () => _getImageVideo(type, false),
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

  void _initRecord() async {
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
        _provider.recording(current);
        _provider.recordingStatus(current.status);
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: const Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  void _startRecord() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      _provider.recording(recording);

      const tick = const Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_provider.isCurrentStatusGet == rec.RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        _provider.recording(current);
        _provider.recordingStatus(_provider.isCurrentGet.status);
      });
    } catch (e) {
      print(e);
    }
  }

  void _stopRecord() async {
    var result = await _recorder.stop();
    _imageVideoAudioFile = localFileSystem.file(result.path);

    _provider.recording(result);
    _provider.recordingStatus(_provider.isCurrentGet.status);

    if (_imageVideoAudioFile != null) {
      _provider.isLoading(true);

      _showDialog(4);
    }

    _initRecord();
  }

  void _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file/local.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart' as rec;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:locationprojectflutter/presentation/pages/video_call.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/chat_screen_provider.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:locationprojectflutter/presentation/widgets/audio_widget.dart';
import 'package:locationprojectflutter/presentation/widgets/full_photo.dart';
import 'package:locationprojectflutter/presentation/widgets/video_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatelessWidget {
  final String peerId, peerAvatar;

  const ChatScreen({
    Key key,
    this.peerId,
    this.peerAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatScreenProvider>(
      builder: (context, results, child) {
        return ChatScreenProv(
          peerId: peerId,
          peerAvatar: peerAvatar,
        );
      },
    );
  }
}

class ChatScreenProv extends StatefulWidget {
  final String peerId, peerAvatar;
  final LocalFileSystem localFileSystem;

  ChatScreenProv(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _ChatScreenProvState createState() => _ChatScreenProvState();
}

class _ChatScreenProvState extends State<ChatScreenProv> {
  final Firestore _firestore = Firestore.instance;
  String _groupChatId = '', _imageVideoAudioUrl = '', _id;
  var _listMessage;
  File _imageVideoAudioFile;
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  rec.FlutterAudioRecorder _recorder;
  ChatScreenProvider _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<ChatScreenProvider>(context, listen: false);
      _provider.isShowSticker(false);
      _provider.isRecordingStatus(rec.RecordingStatus.Initialized);
    });

    _focusNode.addListener(_onFocusChange);

    _initGetSharedPrefs();
    _initRecord();
  }

  @override
  Widget build(BuildContext context) {
    _handleCameraAndMic();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.video_call),
            color: Color(0xFFE9FFFF),
            onPressed: () => {
              _onSendMessage(_idVideo(), 5),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoCall(
                    channelName: _idVideo(),
                    role: ClientRole.Broadcaster,
                  ),
                ),
              ),
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.navigate_before,
            color: Color(0xFFE9FFFF),
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _buildMessagesList(),
              _provider.isShowStickerGet ? _buildStickers() : Container(),
              _buildInput(),
            ],
          ),
          Center(
            child: _provider.isLoadingGet
                ? Container(
                    decoration: BoxDecoration(
                      color: Color(0x80000000),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  Widget _buildStickers() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _stickers('mimi1', 'assets/mimi1.gif'),
              _stickers('mimi2', 'assets/mimi2.gif'),
              _stickers('mimi3', 'assets/mimi3.gif'),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              _stickers('mimi4', 'assets/mimi4.gif'),
              _stickers('mimi5', 'assets/mimi5.gif'),
              _stickers('mimi6', 'assets/mimi6.gif'),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xffE8E8E8),
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5.0),
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
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () => _newTaskModalBottomSheet(context, 1),
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.video_library),
                onPressed: () => _newTaskModalBottomSheet(context, 3),
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: _getSticker,
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: _provider.isCurrentStatusGet ==
                        rec.RecordingStatus.Initialized
                    ? Icon(Icons.mic_none)
                    : Icon(
                        Icons.mic,
                        color: Colors.red,
                      ),
                onPressed: () => _provider.isCurrentStatusGet ==
                        rec.RecordingStatus.Initialized
                    ? _startRecord()
                    : _stopRecord(),
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(
                  color: Color(0xff203152),
                  fontSize: 15.0,
                ),
                controller: _textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Color(0xffaeaeae)),
                ),
                focusNode: _focusNode,
              ),
            ),
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _onSendMessage(_textEditingController.text, 0),
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: ResponsiveScreen().heightMediaQuery(context, 50),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xffE8E8E8),
              width: 0.5,
            ),
          ),
          color: Colors.white),
    );
  }

  Widget _buildMessagesList() {
    return Flexible(
      child: _groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xfff5a623),
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
                        Color(0xfff5a623),
                      ),
                    ),
                  );
                } else {
                  _listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
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

  Widget _buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == _id) {
      return Row(
        children: <Widget>[
          document['type'] == 0
              ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: ResponsiveScreen().widthMediaQuery(context, 200),
                  decoration: BoxDecoration(
                    color: Color(0xff203152),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.only(
                    bottom: _isLastMessageRight(index) ? 20.0 : 10.0,
                    right: 10.0,
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
                                  Color(0xfff5a623),
                                ),
                              ),
                              width: ResponsiveScreen()
                                  .widthMediaQuery(context, 200),
                              height: ResponsiveScreen()
                                  .heightMediaQuery(context, 200),
                              padding: EdgeInsets.all(70.0),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'assets/img_not_available.jpeg',
                                width: ResponsiveScreen()
                                    .widthMediaQuery(context, 200),
                                height: ResponsiveScreen()
                                    .heightMediaQuery(context, 200),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
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
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullPhoto(
                                url: document['content'],
                              ),
                            ),
                          );
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                        bottom: _isLastMessageRight(index) ? 20.0 : 10.0,
                        right: 10.0,
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
                            bottom: _isLastMessageRight(index) ? 20.0 : 10.0,
                            right: 10.0,
                          ),
                        )
                      : document['type'] == 3
                          ? Container(
                              child: VideoWidget(
                                url: document['content'],
                              ),
                              margin: EdgeInsets.only(
                                bottom:
                                    _isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0,
                              ),
                            )
                          : document['type'] == 4
                              ? Container(
                                  width: ResponsiveScreen()
                                      .widthMediaQuery(context, 300),
                                  height: ResponsiveScreen()
                                      .heightMediaQuery(context, 120),
                                  child: AudioWidget(
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
                                        padding: EdgeInsets.fromLTRB(
                                            15.0, 10.0, 15.0, 10.0),
                                        width: ResponsiveScreen()
                                            .widthMediaQuery(context, 200),
                                        decoration: BoxDecoration(
                                          color: Color(0xff203152),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        margin: EdgeInsets.only(
                                          bottom: _isLastMessageRight(index)
                                              ? 20.0
                                              : 10.0,
                                          right: 10.0,
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
                            child: widget.peerAvatar != null
                                ? CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xfff5a623),
                                    ),
                                  )
                                : Container(),
                            width:
                                ResponsiveScreen().widthMediaQuery(context, 35),
                            height: ResponsiveScreen()
                                .heightMediaQuery(context, 35),
                            padding: EdgeInsets.all(10.0),
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
                        borderRadius: BorderRadius.all(
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
                          style: TextStyle(color: Color(0xff203152)),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: ResponsiveScreen().widthMediaQuery(context, 200),
                        decoration: BoxDecoration(
                          color: Color(0xffE8E8E8),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document['type'] == 1
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xfff5a623),
                                      ),
                                    ),
                                    width: ResponsiveScreen()
                                        .widthMediaQuery(context, 200),
                                    height: ResponsiveScreen()
                                        .heightMediaQuery(context, 200),
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xffE8E8E8),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset(
                                      'assets/img_not_available.jpeg',
                                      width: ResponsiveScreen()
                                          .widthMediaQuery(context, 200),
                                      height: ResponsiveScreen()
                                          .heightMediaQuery(context, 200),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
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
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullPhoto(
                                      url: document['content'],
                                    ),
                                  ),
                                );
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(
                              color: Color(0xffE8E8E8),
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
                                margin: EdgeInsets.only(left: 10.0),
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
                                    child: VideoWidget(
                                      url: document['content'],
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xffE8E8E8),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  )
                                : document['type'] == 4
                                    ? Container(
                                        width: ResponsiveScreen()
                                            .widthMediaQuery(context, 300),
                                        height: ResponsiveScreen()
                                            .heightMediaQuery(context, 105),
                                        child: AudioWidget(
                                          url: document['content'],
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xffE8E8E8),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                                              padding: EdgeInsets.fromLTRB(
                                                  15.0, 10.0, 15.0, 10.0),
                                              width: ResponsiveScreen()
                                                  .widthMediaQuery(
                                                      context, 200),
                                              decoration: BoxDecoration(
                                                color: Color(0xffE8E8E8),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              margin:
                                                  EdgeInsets.only(left: 10.0),
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
                        color: Color(0xffaeaeae),
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      left: 50.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
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
        duration: Duration(milliseconds: 300),
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
    List<String> _strList = List();
    _strList.add(_id);
    _strList.add(widget.peerId);
    _strList.sort((a, b) => a.compareTo(b));
    String _strId = _strList[0] + _strList[1];
    return _strId;
  }

  void _videoSendMessage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCall(
          channelName: _idVideo(),
          role: ClientRole.Broadcaster,
        ),
      ),
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
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 20),
                ),
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
                        child: Text(
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
                    SizedBox(
                      width: ResponsiveScreen().widthMediaQuery(context, 20),
                    ),
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
                        child: Text(
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
                            ? Text('Take A Picture')
                            : Text('Take A Video'),
                      ),
                      onTap: () => _getImageVideo(type, true),
                    ),
                    ListTile(
                      title: Center(
                        child: type == 1
                            ? Text('Open A Picture Gallery')
                            : Text('Open A Video Gallery'),
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
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        _recorder = rec.FlutterAudioRecorder(customPath,
            audioFormat: rec.AudioFormat.WAV);

        await _recorder.initialized;
        var current = await _recorder.current(channel: 0);
        _provider.isRecording(current);
        _provider.isRecordingStatus(current.status);
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  void _startRecord() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      _provider.isRecording(recording);

      const tick = const Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_provider.isCurrentStatusGet == rec.RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        _provider.isRecording(current);
        _provider.isRecordingStatus(_provider.isCurrentGet.status);
      });
    } catch (e) {
      print(e);
    }
  }

  void _stopRecord() async {
    var result = await _recorder.stop();
    _imageVideoAudioFile = widget.localFileSystem.file(result.path);

    _provider.isRecording(result);
    _provider.isRecordingStatus(_provider.isCurrentGet.status);

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

import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/chat_screen_provider.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/appbar_total.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:locationprojectflutter/presentation/widgets/full_photo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class ChatScreen extends StatelessWidget {
  final String peerId;
  final String peerAvatar;

  ChatScreen({
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
  final String peerId;
  final String peerAvatar;

  ChatScreenProv({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  State createState() =>
      _ChatScreenProvState(peerId: peerId, peerAvatar: peerAvatar);
}

class _ChatScreenProvState extends State<ChatScreenProv> {
  _ChatScreenProvState(
      {Key key, @required this.peerId, @required this.peerAvatar});

  final Firestore _firestore = Firestore.instance;
  String peerId, peerAvatar, _groupChatId = '', _imageVideoUrl = '', _id;
  var _listMessage, _provider;
  File _imageVideoFile;
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ChatScreenProvider>(context, listen: false);

    _focusNode.addListener(_onFocusChange);

    _initGetSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTotal(),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _buildMessagesList(),
              _provider.isShowStickerGet ? _buildSticker() : Container(),
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
      drawer: DrawerTotal(),
    );
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _provider.isShowSticker(false);
    }
  }

  Widget _buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => _onSendMessage('mimi1', 2),
                child: Image.asset(
                  'assets/mimi1.gif',
                  width: ResponsiveScreen().widthMediaQuery(context, 50),
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => _onSendMessage('mimi2', 2),
                child: Image.asset(
                  'assets/mimi2.gif',
                  width: ResponsiveScreen().widthMediaQuery(context, 50),
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => _onSendMessage('mimi3', 2),
                child: Image.asset(
                  'assets/mimi3.gif',
                  width: ResponsiveScreen().widthMediaQuery(context, 50),
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => _onSendMessage('mimi4', 2),
                child: Image.asset(
                  'assets/mimi4.gif',
                  width: ResponsiveScreen().widthMediaQuery(context, 50),
                  height: ResponsiveScreen().heightMediaQuery(context, 50),
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => _onSendMessage('mimi5', 2),
                child: Image.asset(
                  'assets/mimi5.gif',
                  width: ResponsiveScreen().widthMediaQuery(context, 50),
                  height: ResponsiveScreen().heightMediaQuery(context, 50),
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => _onSendMessage('mimi6', 2),
                child: Image.asset(
                  'assets/mimi6.gif',
                  width: ResponsiveScreen().widthMediaQuery(context, 50),
                  height: ResponsiveScreen().heightMediaQuery(context, 50),
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => _onSendMessage('mimi7', 2),
                child: Image.asset(
                  'assets/mimi7.gif',
                  width: ResponsiveScreen().widthMediaQuery(context, 50),
                  height: ResponsiveScreen().heightMediaQuery(context, 50),
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => _onSendMessage('mimi8', 2),
                child: Image.asset(
                  'assets/mimi8.gif',
                  width: ResponsiveScreen().widthMediaQuery(context, 50),
                  height: ResponsiveScreen().heightMediaQuery(context, 50),
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => _onSendMessage('mimi9', 2),
                child: Image.asset(
                  'assets/mimi9.gif',
                  width: ResponsiveScreen().widthMediaQuery(context, 50),
                  height: ResponsiveScreen().heightMediaQuery(context, 50),
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
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

  Widget _buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 1.0,
              ),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: () => _getImageVideo(1),
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
                onPressed: () => _getImageVideo(3),
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
                    style: TextStyle(color: Color(0xff203152)),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: ResponsiveScreen().widthMediaQuery(context, 200),
                  decoration: BoxDecoration(
                    color: Color(0xffE8E8E8),
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
                              decoration: BoxDecoration(
                                color: Color(0xffE8E8E8),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
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
                  : document['type'] == 3
                      ? Container(
                          child: Container(
                            width: ResponsiveScreen()
                                .widthMediaQuery(context, 200),
                            height: ResponsiveScreen()
                                .heightMediaQuery(context, 200),
                            key: PageStorageKey(
                              "keydata$index",
                            ),
                            child: VideoWidget(
                              play: true,
                              url: document['content'],
                            ),
                          ),
                          margin: EdgeInsets.only(
                            bottom: _isLastMessageRight(index) ? 20.0 : 10.0,
                            right: 10.0,
                          ),
                        )
                      : Container(
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
                        ),
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
                            child: peerAvatar != null
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
                          imageUrl: peerAvatar != null ? peerAvatar : '',
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
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: ResponsiveScreen().widthMediaQuery(context, 200),
                        decoration: BoxDecoration(
                          color: Color(0xff203152),
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
                          )
                        : document['type'] == 3
                            ? Container(
                                child: Container(
                                  width: ResponsiveScreen()
                                      .widthMediaQuery(context, 200),
                                  height: ResponsiveScreen()
                                      .heightMediaQuery(context, 200),
                                  key: PageStorageKey(
                                    "keydata$index",
                                  ),
                                  child: VideoWidget(
                                    play: true,
                                    url: document['content'],
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 10.0),
                              )
                            : Container(
                                child: Image.asset(
                                  'assets/${document['content']}.gif',
                                  width: ResponsiveScreen()
                                      .widthMediaQuery(context, 100),
                                  height: ResponsiveScreen()
                                      .heightMediaQuery(context, 100),
                                  fit: BoxFit.cover,
                                ),
                                margin: EdgeInsets.only(left: 10.0),
                              ),
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
        if (_id.hashCode <= peerId.hashCode) {
          _groupChatId = '$_id-$peerId';
        } else {
          _groupChatId = '$peerId-$_id';
        }
      },
    ).then(
      (value) => _readLocal(),
    );
  }

  void _readLocal() async {
    await _firestore.collection('users').document(_id).updateData(
      {
        'chattingWith': peerId,
      },
    ).then(
      (value) => print(peerId),
    );
  }

  void _getImageVideo(int type) async {
    if (type == 1) {
      _imageVideoFile =
          await ImagePicker.pickImage(source: ImageSource.gallery);
    } else if (type == 3) {
      _imageVideoFile =
          await ImagePicker.pickVideo(source: ImageSource.gallery);
    }

    if (_imageVideoFile != null) {
      _provider.isLoading(true);
      _showDialog(type);
    }
  }

  void _getSticker() {
    _focusNode.unfocus();
    _provider.isShowSticker(!_provider.isLoadingGet);
  }

  void _uploadFile(int type) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask;
    if (type == 3) {
      uploadTask = reference.putFile(
        _imageVideoFile,
        StorageMetadata(contentType: 'video/mp4'),
      );
    } else if (type == 1) {
      uploadTask = reference.putFile(
        _imageVideoFile,
      );
    }
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then(
      (downloadUrl) {
        _imageVideoUrl = downloadUrl;

        _provider.isLoading(false);
        _onSendMessage(_imageVideoUrl, type);
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

  Future _showDialog(int type) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                type == 1
                    ? "Would you want to send this image?"
                    : type == 3 ? "Would you want to send this video?" : '',
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
        );
      },
    );
  }
}

class VideoWidget extends StatefulWidget {
  final bool play;
  final String url;

  const VideoWidget({Key key, @required this.url, @required this.play})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
  }

  @override
  void dispose() {
    super.dispose();

    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            child: Card(
              key: PageStorageKey(widget.url),
              elevation: 5.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chewie(
                      key: PageStorageKey(widget.url),
                      controller: ChewieController(
                        videoPlayerController: _videoPlayerController,
                        aspectRatio: 1,
                        autoInitialize: true,
                        looping: false,
                        autoPlay: false,
                        errorBuilder: (context, errorMessage) {
                          return Center(
                            child: Text(
                              errorMessage,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

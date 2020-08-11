import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/core/constants/constants.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/video_call_provider.dart';
import 'package:provider/provider.dart';

class VideoCall extends StatelessWidget {
  final String channelName;
  final ClientRole role;

  const VideoCall({
    Key key,
    this.channelName,
    this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoCallProvider>(
      builder: (context, results, child) {
        return VideoCallProv(
          channelName: channelName,
          role: role,
        );
      },
    );
  }
}

class VideoCallProv extends StatefulWidget {
  final String channelName;
  final ClientRole role;

  const VideoCallProv({Key key, this.channelName, this.role}) : super(key: key);

  @override
  _VideoCallProvState createState() => _VideoCallProvState();
}

class _VideoCallProvState extends State<VideoCallProv> {
  String _AGORA_KEY = Constants.AGORA_KEY;
  VideoCallProvider _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<VideoCallProvider>(context, listen: false);
      _provider.isMuted(false);
      _provider.isInfoStringsClear();
      _provider.isUsersClear();
    });

    _initialize();
  }

  @override
  void dispose() {
    super.dispose();

    _provider.isUsersClear();

    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: Stack(
        children: <Widget>[
          _viewRows(),
//            _panel(),
          _toolbar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      leading: IconButton(
        icon: Icon(
          Icons.navigate_before,
          color: Color(0xFFE9FFFF),
          size: 40,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(AgoraRenderWidget(0, local: true, preview: true));
    }
    _provider.isUsersGet.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              _provider.isMutedGet ? Icons.mic_off : Icons.mic,
              color: _provider.isMutedGet ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: _provider.isMutedGet ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

//  Widget _panel() {
//    return Container(
//      padding: const EdgeInsets.symmetric(vertical: 48),
//      alignment: Alignment.bottomCenter,
//      child: FractionallySizedBox(
//        heightFactor: 0.5,
//        child: Container(
//          padding: const EdgeInsets.symmetric(vertical: 48),
//          child: ListView.builder(
//            reverse: true,
//            itemCount: _provider.isInfoStringsGet.length,
//            itemBuilder: (BuildContext context, int index) {
//              if (_provider.isInfoStringsGet.isEmpty) {
//                return null;
//              }
//              return Padding(
//                padding: const EdgeInsets.symmetric(
//                  vertical: 3,
//                  horizontal: 10,
//                ),
//                child: Row(
//                  mainAxisSize: MainAxisSize.min,
//                  children: [
//                    Flexible(
//                      child: Container(
//                        padding: const EdgeInsets.symmetric(
//                          vertical: 2,
//                          horizontal: 5,
//                        ),
//                        decoration: BoxDecoration(
//                          color: Colors.yellowAccent,
//                          borderRadius: BorderRadius.circular(5),
//                        ),
//                        child: Text(
//                          _provider.isInfoStringsGet[index],
//                          style: TextStyle(color: Colors.blueGrey),
//                        ),
//                      ),
//                    )
//                  ],
//                ),
//              );
//            },
//          ),
//        ),
//      ),
//    );
//  }

  void _initialize() async {
    if (_AGORA_KEY.isEmpty) {
      _provider.isInfoStringsAdd(
          'APP_ID missing, please provide your APP_ID in settings.dart');
      _provider.isInfoStringsAdd('Agora Engine is not starting');
      return;
    }

    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = Size(1920, 1080);
    await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  void _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(_AGORA_KEY);
    await AgoraRtcEngine.enableVideo();
    await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await AgoraRtcEngine.setClientRole(widget.role);
  }

  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      final info = 'onError: $code';
      _provider.isInfoStringsAdd(info);
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      final info = 'onJoinChannel: $channel, uid: $uid';
      _provider.isInfoStringsAdd(info);
    };

    AgoraRtcEngine.onLeaveChannel = () {
      _provider.isInfoStringsAdd('onLeaveChannel');
      _provider.isUsersClear();
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      final info = 'userJoined: $uid';
      _provider.isInfoStringsAdd(info);
      _provider.isUsersAdd(uid);
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      final info = 'userOffline: $uid';
      _provider.isInfoStringsAdd(info);
      _provider.isUsersRemove(uid);
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      final info = 'firstRemoteVideo: $uid ${width}x $height';
      _provider.isInfoStringsAdd(info);
    };
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    _provider.isMuted(!_provider.isMutedGet);
    AgoraRtcEngine.muteLocalAudioStream(_provider.isMutedGet);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }
}

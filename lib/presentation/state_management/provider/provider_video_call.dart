import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:locationprojectflutter/core/constants/constants_urls_keys.dart';

class ProviderVideoCall extends ChangeNotifier {
  final String _AGORA_KEY = ConstantsUrlsKeys.API_KEY_AGORA;
  List<int> _users = [];
  List<String> _infoStrings = [];
  bool _isMuted = false;

  String get AGORA_KEYGet => _AGORA_KEY;

  List<int> get isUsersGet => _users;

  List<String> get isInfoStringsGet => _infoStrings;

  bool get isMutedGet => _isMuted;

  void usersAdd(int users) {
    _users.add(users);
    notifyListeners();
  }

  void usersRemove(int users) {
    _users.remove(users);
    notifyListeners();
  }

  void usersClear() {
    _users.clear();
    notifyListeners();
  }

  void infoStringsAdd(String infoStrings) {
    _infoStrings.add(infoStrings);
    notifyListeners();
  }

  void infoStringsClear() {
    _infoStrings.clear();
    notifyListeners();
  }

  void isMuted(bool isMuted) {
    _isMuted = isMuted;
    notifyListeners();
  }

  void initialize(String channelName, ClientRole role) async {
    if (_AGORA_KEY.isEmpty) {
      infoStringsAdd(
          'APP_ID missing, please provide your APP_ID in settings.dart');
      infoStringsAdd('Agora Engine is not starting');
      return;
    }

    _initAgoraRtcEngine(role);
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const Size(1920, 1080);
    await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
    await AgoraRtcEngine.joinChannel(null, channelName, null, 0);
  }

  void _initAgoraRtcEngine(ClientRole role) async {
    await AgoraRtcEngine.create(_AGORA_KEY);
    await AgoraRtcEngine.enableVideo();
    await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await AgoraRtcEngine.setClientRole(role);
  }

  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      final info = 'onError: $code';
      infoStringsAdd(info);
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      final info = 'onJoinChannel: $channel, uid: $uid';
      infoStringsAdd(info);
    };

    AgoraRtcEngine.onLeaveChannel = () {
      infoStringsAdd('onLeaveChannel');
      usersClear();
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      final info = 'userJoined: $uid';
      infoStringsAdd(info);
      usersAdd(uid);
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      final info = 'userOffline: $uid';
      infoStringsAdd(info);
      usersRemove(uid);
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      final info = 'firstRemoteVideo: $uid ${width}x $height';
      infoStringsAdd(info);
    };
  }

  void onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void onToggleMute() {
    isMuted(!isMutedGet);
    AgoraRtcEngine.muteLocalAudioStream(isMutedGet);
  }

  void onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }
}

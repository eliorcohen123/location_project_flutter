import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayer/audioplayer.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class AudioWidget extends StatefulWidget {
  final String url;

  const AudioWidget({this.url});

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _audioPlayerStateSubscription;

  get isPlaying => _playerState == PlayerState.playing;

  get isPaused => _playerState == PlayerState.paused;

  @override
  void initState() {
    super.initState();

    initAudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();

    _audioPlayerStateSubscription.cancel();
    _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buttonStart(),
              _buttonPause(),
              _buttonStop(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonStart() {
    return IconButton(
      onPressed: isPlaying ? null : () => _play(),
      iconSize: 64.0,
      icon: const Icon(Icons.play_arrow),
      color: Colors.indigoAccent,
    );
  }

  Widget _buttonPause() {
    return IconButton(
      onPressed: isPlaying ? () => _pause() : null,
      iconSize: 64.0,
      icon: const Icon(Icons.pause),
      color: Colors.indigoAccent,
    );
  }

  Widget _buttonStop() {
    return IconButton(
      onPressed: isPlaying || isPaused ? () => _stop() : null,
      iconSize: 64.0,
      icon: const Icon(Icons.stop),
      color: Colors.indigoAccent,
    );
  }

  void initAudioPlayer() {
    _audioPlayerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.COMPLETED) {
        _onComplete();
      }
    }, onError: (msg) {
      setState(() {
        _playerState = PlayerState.stopped;
      });
    });
  }

  void _play() async {
    await _audioPlayer.play(widget.url);
    setState(() => _playerState = PlayerState.playing);
  }

  void _pause() async {
    await _audioPlayer.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  void _stop() async {
    await _audioPlayer.stop();
    setState(() => _playerState = PlayerState.stopped);
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
}

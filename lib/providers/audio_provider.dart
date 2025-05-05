import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    await _player.setVolume(_isMuted ? 0.0 : 1.0);
    notifyListeners();
  }

  Future<void> playSound(String asset) async {
    if (!_isMuted) {
      await _player.play(AssetSource('audio/$asset'));
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
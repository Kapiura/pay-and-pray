import 'package:audioplayers/audioplayers.dart';

class AudioHandler {
  static final AudioPlayer _bgPlayer = AudioPlayer();
  static bool _isMuted = false;

  static Future<void> init() async {
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.setSource(AssetSource('audio/background.mp3'));
    await _bgPlayer.setVolume(0.3);
  }

  static Future<void> playBackground() async {
    if (_isMuted) return;
    await _bgPlayer.resume();
  }

  static Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    await _bgPlayer.setVolume(_isMuted ? 0.0 : 0.3);
  }

  static bool get isMuted => _isMuted;

  static Future<void> dispose() async {
    await _bgPlayer.dispose();
  }
}
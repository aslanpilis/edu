import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  AudioPlayer? _player;
  bool _soundEnabled = true;

  void init() {
    try {
      _player = AudioPlayer();
    } catch (e) {
      debugPrint('AudioPlayer init error: $e');
    }
  }

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  Future<void> playPop() async {
    if (!_soundEnabled || _player == null) return;
    try {
      // In a production app, assets like assets/audio/pop.mp3 are used
      debugPrint('🎵 Audio Cue: POP');
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> playSuccess() async {
    if (!_soundEnabled || _player == null) return;
    try {
      debugPrint('🎵 Audio Cue: SUCCESS FANFARE');
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> playTryAgain() async {
    if (!_soundEnabled || _player == null) return;
    try {
      debugPrint('🎵 Audio Cue: GENTLE TRY AGAIN');
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> playStar() async {
    if (!_soundEnabled || _player == null) return;
    try {
      debugPrint('🎵 Audio Cue: STAR UNLOCKED');
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }
}

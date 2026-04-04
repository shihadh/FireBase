import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();

  TTSService() {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.48);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(0.9);
    // On Android, Google TTS
    _flutterTts.setEngine("com.google.android.tts");
  }

  Future<void> speak(String text) async {
    await stop(); // Prevent overlapping audio
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}

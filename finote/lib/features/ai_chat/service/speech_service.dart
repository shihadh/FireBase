import 'package:speech_to_text/speech_to_text.dart';
import 'dart:developer';

class SpeechService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Future<bool> init(Function(String) onStatus) async {
    if (!_isInitialized) {
      _isInitialized = await _speechToText.initialize(
        onStatus: onStatus,
        onError: (err) => log("Speech Error: ${err.errorMsg}"),
      );
    }
    return _isInitialized;
  }

  Future<void> startListening({
    required Function(String, bool) onResult,
    Duration pauseFor = const Duration(seconds: 5),
  }) async {
    if (!_isInitialized) return;
    await _speechToText.listen(
      onResult: (res) => onResult(res.recognizedWords, res.finalResult),
      pauseFor: pauseFor, 
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        cancelOnError: true,
        partialResults: true,
      ),
    );
  }

  Future<void> stop() async {
    await _speechToText.stop();
  }

  Future<void> cancel() async {
    await _speechToText.cancel();
  }

  bool get isListening => _speechToText.isListening;
}

/// On-device speech recognition. The transcript goes into the chat text field for review before sending.
library;

import 'package:speech_to_text/speech_to_text.dart';

class VoiceInput {
  final SpeechToText _speech = SpeechToText();
  bool _ready = false;

  bool get isListening => _speech.isListening;

  Future<bool> _init() async {
    if (_ready) return true;
    _ready = await _speech.initialize();
    return _ready;
  }

  /// Starts listening. [onText] receives the transcript so far; [onDone] fires when recognition stops.
  /// Returns false when speech recognition is unavailable or the permission was denied.
  Future<bool> start({required void Function(String text) onText, required void Function() onDone}) async {
    if (!await _init()) return false;
    await _speech.listen(
      onResult: (r) {
        onText(r.recognizedWords);
        if (r.finalResult) onDone();
      },
      listenOptions: SpeechListenOptions(
        partialResults: true,
        onDevice: true,
        cancelOnError: true,
        listenMode: ListenMode.dictation,
        pauseFor: const Duration(seconds: 3),
        listenFor: const Duration(minutes: 1),
      ),
    );
    return true;
  }

  Future<void> stop() => _speech.stop();
}

import 'package:flutter_tts/flutter_tts.dart';

class TTSVoice {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }
}

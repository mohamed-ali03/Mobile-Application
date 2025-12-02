import 'package:flutter_tts/flutter_tts.dart';

class TtsModule {
  static final FlutterTts _flutterTts = FlutterTts();

  static Future<void> init() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.3);
  }

  static Future<void> speakText(String text) async {
    await _flutterTts.speak(text);
  }

  static Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }
}

import 'package:first_app/tts_module.dart';
import 'package:flutter/material.dart';

class Voicepage extends StatefulWidget {
  const Voicepage({super.key});

  @override
  State<Voicepage> createState() => _VoicepageState();
}

class _VoicepageState extends State<Voicepage> {
  @override
  void initState() {
    TtsModule.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () => TtsModule.speakText(
            'His shirt was creased after sitting for a long time.',
          ),
          icon: Icon(Icons.speaker, size: 100),
        ),
      ),
    );
  }
}

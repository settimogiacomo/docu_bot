import 'package:flutter/material.dart';
import 'costanti.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

@override
class ButtonTextToSpeech extends StatelessWidget {
  final String? testoDaLeggere;

  ButtonTextToSpeech({
    super.key,
    required this.testoDaLeggere,
  });

  late FlutterTts flutterTts = FlutterTts();

  String? language = 'italian';
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.7;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  // bool get isIOS => !kIsWeb && Platform.isIOS;
  // bool get isAndroid => !kIsWeb && Platform.isAndroid;
  // bool get isWindows => !kIsWeb && Platform.isWindows;
  // bool get isWeb => kIsWeb;

  Future<void> _speak() async {
    //List<dynamic> languages = await flutterTts.getLanguages;
    //await flutterTts.getDefaultVoice;
    await flutterTts.setLanguage("it-IT");
    if(isPlaying){
      await flutterTts.stop();
    } else {
      await flutterTts.setVolume(volume);
      await flutterTts.setSpeechRate(rate);
      await flutterTts.setPitch(pitch);

      if (testoDaLeggere != null) {
        if (testoDaLeggere!.isNotEmpty) {
          await flutterTts.speak(testoDaLeggere!);
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 37.0,
        decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            border: Border.all(
              color: Colors.lightBlueAccent,
            ),
            borderRadius: BorderRadius.circular(BORDER_RADIUS)),
        child: TextButton(
            style: ButtonStyle(
                iconColor: MaterialStateProperty.all(Colors.white),
                alignment: Alignment.center),
            onPressed: () async { _speak();},
            child: ELEM_PLAY));
  }
}

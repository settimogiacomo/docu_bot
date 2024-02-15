import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'costanti.dart';

@override
class ButtonSpeechToText extends StatefulWidget {
  final TextEditingController controllerTextBoxParent;
  final FocusNode focusTextBoxParent;

  ButtonSpeechToText({
    required this.controllerTextBoxParent,
    required this.focusTextBoxParent,
  });
  @override
  _ButtonSpeechToText createState() => _ButtonSpeechToText();
}

class _ButtonSpeechToText extends State<ButtonSpeechToText> {

  late TextEditingController _controllerTextBox;
  late FocusNode _focusTextBox;
  @override
  void initState() {
    super.initState();
    _controllerTextBox = widget.controllerTextBoxParent;
    _focusTextBox = widget.focusTextBoxParent;
  }

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _ultimeParole = '';
  Icon _iconaMicrofono = Icon(Icons.mic_off_rounded);

  void _initSpeech() async {
    print("INIZIALIZZAZIONE");
    _speechEnabled = await _speechToText.initialize();
    print("speech enabled: " + _speechEnabled.toString());
    setState(() {});
  }

  void _salvaParoleSpeech(SpeechRecognitionResult risultato) {
    print(risultato.recognizedWords);
    _ultimeParole = risultato.recognizedWords;
    setState(() {
      _controllerTextBox.value = TextEditingValue(
        text: _ultimeParole,
        selection: TextSelection.fromPosition(
            TextPosition(offset: _ultimeParole.length)),
      );
    });
  }

  void _inizioAscolto() async {
    if (!_speechEnabled) {
      _speechEnabled = await _speechToText.initialize();
    }
    _ultimeParole = '';
    try {
      await _speechToText.listen(
          listenFor: const Duration(seconds: 60),
          pauseFor: const Duration(seconds: 30),
          cancelOnError: false,
          partialResults: true,
          listenMode: ListenMode.dictation,
          onResult: _salvaParoleSpeech);
    } catch (ex) {
      print("ERRORE MICROFONO");
      print(ex.toString());
    }

    setState(() {
      _iconaMicrofono = Icon(Icons.mic);
    });
  }

  void _fineAscolto() async {
    await _speechToText.stop();
    _speechEnabled = false;
    _focusTextBox.requestFocus();
    setState(() {
      _iconaMicrofono = Icon(Icons.mic_off_rounded);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      width: 80.0,
      decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          border: Border.all(
            color: Colors.lightBlueAccent,
          ),
          borderRadius: BorderRadius.all(
              Radius.circular(BORDER_RADIUS))),
      child: TextButton(
        style: ButtonStyle(
            iconColor:
            MaterialStateProperty.all(Colors.white)),
        child: _iconaMicrofono,
        onPressed: () {
          setState(() {
            print("State listening: " +
                _isListening.toString());
            if (_isListening) {
              _fineAscolto();
              _isListening = false;
              print("chiuso ascolto");
            } else {
              print("aperto ascolto");
              _inizioAscolto();
              _isListening = true;
            }
          });
        },
      ),
    );
  }

}



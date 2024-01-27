import 'costanti.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'request.dart';



class SchermataChat extends StatefulWidget {
  @override
  _StatoSchermataChat createState() => _StatoSchermataChat();
}

class _StatoSchermataChat extends State<SchermataChat> {
  List<String> _messaggiChat = [];
  TextEditingController _controllerTesto = TextEditingController(text: "");
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _ultimeParole = '';
  FocusNode _focusTestoUtente = FocusNode();
  Icon _iconaMicrofono =  Icon(Icons.mic_off_rounded);
  int? _numeroMaxLinee = null;


  void _initSpeech() async{
    print("INIZIALIZZAZIONE");
    _speechEnabled = await _speechToText.initialize();
    print("speech enabled: " + _speechEnabled.toString());
    setState(() {});
  }

  void _salvaParoleSpeech(SpeechRecognitionResult risultato){
    print(risultato.recognizedWords);
    _ultimeParole = risultato.recognizedWords;
    setState(() {
      _controllerTesto.value = TextEditingValue(
        text: _ultimeParole,
        selection: TextSelection.fromPosition(
            TextPosition(offset: _ultimeParole.length)
        ),
      );
    });
  }
  void _inizioAscolto() async {
    if(!_speechEnabled){
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
    } catch(ex){
      print("ERRORE MICROFONO");
      print(ex.toString());
    }

    setState(() {
      _iconaMicrofono =  Icon(Icons.mic);
    });
  }
  void _fineAscolto() async {
    await _speechToText.stop();
    _speechEnabled = false;
    _focusTestoUtente.requestFocus();
    setState(() {
      _iconaMicrofono =  Icon(Icons.mic_off_rounded);
    });
  }



  void _gestisciMessaggioInviato(String messaggio) {
    if (messaggio.isNotEmpty) {
      //Invia messaggio all'Api
      _inviaEMostraRisposta(messaggio);
    }
  }

  Future<void> _inviaEMostraRisposta(String messaggio) async {
    //Inserisce la domanda dell'utente nel quadrante
    setState(() {
      _messaggiChat.add(messaggio);
      _controllerTesto.clear();
    });
    // Feedback immediato di risposta
    setState(() {
      _messaggiChat.add("...");
    });

    // Invia messaggio all'API
    // Inserisce messaggio utente
    final risposta  = await ottieniRisposta(messaggio);

    // Aggiorna la chat con la risposta
    setState(() {
      _messaggiChat[_messaggiChat.length-1] = risposta;
    });
    _focusTestoUtente.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: Colors.black26,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(BORDER_RADIUS),
                ),
                height: MediaQuery.of(context).size.height - 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top:10),
                      child: Text(
                        "Chat",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: FONTSIZE+5.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _messaggiChat.length,
                        itemBuilder: (context, index) {
                          final isMessaggioUtente = index % 2 == 0;
                          return ListTile(
                            title: Align(
                              alignment: isMessaggioUtente ? Alignment.topRight : Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment: isMessaggioUtente ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  // Usa l'icona dell'utente per il messaggio dell'utente
                                  Visibility(
                                    visible: !isMessaggioUtente,
                                    child: Icon(BOT__ICON),
                                  ),
                                  SizedBox(width: 8), // Adjust the spacing between icon and text
                                  Flexible(
                                    child:
                                    SelectableText(
                                      _messaggiChat[index],
                                      style: TextStyle(fontSize: FONTSIZE),
                                    ),
                                  ),
                                  Visibility(
                                    visible: isMessaggioUtente,
                                    child: Icon(USER_ICON),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom:10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Container(
                                constraints: const BoxConstraints(maxHeight: 200),
                                child: TextField(
                                  maxLines: _numeroMaxLinee,
                                  focusNode: _focusTestoUtente,
                                  controller: _controllerTesto,
                                  decoration: InputDecoration(
                                    hintText: "Scrivi una domanda",
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(BORDER_RADIUS),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  ),
                                  onSubmitted: _gestisciMessaggioInviato,
                                ),
                              ),

                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 45.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                border: Border.all(
                                  color: Colors.lightBlueAccent,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(BORDER_RADIUS))
                            ),
                            child: TextButton(
                              style: ButtonStyle(iconColor: MaterialStateProperty.all(Colors.white)),
                              child: _iconaMicrofono,
                              onPressed: () {
                                setState(() {
                                  print("State listening: " + _isListening.toString());
                                  if(_isListening){
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
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 45.0,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(BORDER_RADIUS),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _inviaEMostraRisposta(_controllerTesto.text);
                                });
                              },
                              icon: const Icon(Icons.send),
                              label: const Text("Invia"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 45.0,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(BORDER_RADIUS),
                                  ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _messaggiChat.clear();
                                  _controllerTesto.clear();
                                });
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text("Svuota Chat"),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

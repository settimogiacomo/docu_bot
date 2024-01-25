

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'costanti.dart';
import 'request.dart';


class ElencoFileCaricati {
  List<String> _fileCaricati = [];

  void aggiungiFile(String nomeFile) {
    _fileCaricati.add(nomeFile);
  }

  List<String> get elencoCompleto => _fileCaricati;
  int get contaFileCaricati => _fileCaricati.length;
}


final TextEditingController _controllerTesto = TextEditingController(text: "");
List<String> _messaggiChat = [];
var _lingua = 'Italiano';
var _nomeModello = 'google/flan-t5-xxl';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DocuBot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'DocuBot'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final ElencoFileCaricati _elencoFileCaricati = ElencoFileCaricati();
  var _hasContent = false;
  var _fileSelezionato = -1;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String nomeFile = result.files.single.name;
      setState(() {
        _elencoFileCaricati.aggiungiFile(nomeFile);
      });
    } else {
      // L'utente ha annullato la selezione del file
    }
    _hasContent = (_elencoFileCaricati.contaFileCaricati > 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white70,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          LabelDropDown(etichetta: "Lingua", lista: <String>["Italiano", "Inglese", "Spagnolo", "Tedesco"], valoreDefault: _lingua, icona: Icons.flag),
                        ]
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LabelDropDown(etichetta: "Modello", lista: <String>["google/flan-t5-xxl", "google/flan-t5-large", "tiiuae/falcon-7b-instruct"], valoreDefault: _nomeModello, icona: Icons.mode_fan_off_rounded),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.attach_file),
                        const SizedBox(width: 8),
                        Text('Carica', style: TextStyle(fontSize: FONTSIZE)),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: StadiumBorder()),
                          onPressed: _pickFile,
                          child: const Text('Carica un file'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                      visible: _hasContent,
                      child: Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListView.builder(
                            itemCount: _elencoFileCaricati.contaFileCaricati,
                            itemBuilder: (context, index) {
                              return Align(
                                alignment: Alignment.topRight,
                                child: ListTile(
                                  title: Text(_elencoFileCaricati.elencoCompleto[index],
                                      style: TextStyle(fontSize: FONTSIZE)
                                  ),
                                  tileColor: _fileSelezionato == index ? Colors.blue : null,
                                  onTap: () {
                                    setState(() {
                                      _fileSelezionato = index;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 2,
            color: Colors.black,
          ),
          Expanded(
            flex: 3,
            child: SchermataChat(),
          ),
        ],
      ),
    );
  }
}

class SchermataChat extends StatefulWidget {
  @override
  _StatoSchermataChat createState() => _StatoSchermataChat();
}

class _StatoSchermataChat extends State<SchermataChat> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _ultimeParole = '';


  void _initSpeech() async{
    print("INIZIALIZZAZIONE");
    _speechEnabled = await _speechToText.initialize();
    print(_speechEnabled);
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
    await _speechToText.listen(
        pauseFor: const Duration(seconds: 30),
        cancelOnError: true,
        onResult: _salvaParoleSpeech);
    setState(() {});
  }
  void _fineAscolto() async {
    await _speechToText.stop();
    _speechEnabled = false;
    setState(() {});
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                  borderRadius: BorderRadius.circular(15),
                ),
                height: MediaQuery.of(context).size.height - 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                              child: TextField(
                                controller: _controllerTesto,
                                decoration: InputDecoration(
                                  hintText: "Scrivi una domanda",
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                ),
                                onSubmitted: _gestisciMessaggioInviato,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent, shape: StadiumBorder()),
                            onPressed: () {
                              setState(() {
                                print("Starting: state listening  " + _isListening.toString());
                                if(_isListening){
                                  _fineAscolto();
                                  _isListening = false;
                                } else {
                                  _inizioAscolto();
                                  _isListening = true;
                                }
                              });
                            },
                            icon: const Icon(Icons.mic),
                            label: const Text(""),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: StadiumBorder()),
                            onPressed: () {
                              setState(() {
                                _inviaEMostraRisposta(_controllerTesto.text);
                              });
                            },
                            icon: const Icon(Icons.send),
                            label: const Text("Invia"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: StadiumBorder()),
                            onPressed: () {
                              setState(() {
                                _messaggiChat.clear();
                                _controllerTesto.clear();
                              });
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text("Svuota Chat"),
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

class LabelDropDown extends StatefulWidget {
  final String etichetta;
  final List<String> lista;
  String valoreDefault;
  final IconData icona;

  LabelDropDown({
    required this.etichetta,
    required this.lista,
    required this.valoreDefault,
    required this.icona,
  });

  @override
  _LabelDropDownState createState() => _LabelDropDownState();
}

class _LabelDropDownState extends State<LabelDropDown> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: <Widget>[
            Icon(widget.icona),
            const SizedBox(width: 8),
            Text(widget.etichetta, style: TextStyle(fontSize: FONTSIZE)),
          ],
        ),
        const SizedBox(width: 5),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black38, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.5),
            child: Container(
              width: 230,
              child: DropdownButton<String>(
                underline: Container(),
                isDense: true,
                value: widget.valoreDefault,
                onChanged: (String? newValue) {
                  setState(() {
                    widget.valoreDefault = newValue!;
                  });
                },
                isExpanded: true,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: FONTSIZE,
                ),
                items: widget.lista.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(
                      child: Text(value, style: TextStyle(fontSize: FONTSIZE)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

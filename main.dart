import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ElencoFileCaricati {
  List<String> _fileCaricati = [];

  void aggiungiFile(String nomeFile) {
    _fileCaricati.add(nomeFile);
  }

  List<String> get elencoCompleto => _fileCaricati;

  int get numeroFileCaricati => _fileCaricati.length;
}

List<String> _messaggiChat = [];
const double FONTSIZE = 13.5;

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
      home: const MyHomePage(title: 'DocuBot Home Page'),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  LabelDropDown(etichetta: "Lingua", lista: <String>["Italiano", "Inglese", "Spagnolo", "Tedesco"], valoreDefault: 'Italiano', icona: Icons.flag),
                  const SizedBox(height: 20),
                  LabelDropDown(etichetta: "Modello", lista: <String>["google/flan-t5-xxl", "google/flan-t5-large", "tiiuae/falcon-7b-instruct"], valoreDefault: 'google/flan-t5-xxl', icona: Icons.mode_fan_off_rounded),
                  const SizedBox(height: 80),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_file),
                      const SizedBox(width: 8),
                      Text('Carica', style: TextStyle(fontSize: FONTSIZE)),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _pickFile,
                        child: const Text('Carica un file'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 50, right: 50, bottom: 50),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListView.builder(
                        itemCount: _elencoFileCaricati.numeroFileCaricati,
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: Alignment.topRight,
                            child: ListTile(
                              title: Text(_elencoFileCaricati.elencoCompleto[index], style: TextStyle(fontSize: FONTSIZE)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
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

const IconData userIcon = Icons.account_circle_rounded;
const IconData responseIcon = Icons.adb;

class _StatoSchermataChat extends State<SchermataChat> {
  final TextEditingController _controllerTesto = TextEditingController(text: "");

  void _gestisciMessaggioInviato(String messaggio) {
    if (messaggio.isNotEmpty) {
      //Invia messaggio all'Api
      _inviaEMostraRisposta(messaggio);
    }
  }

  Future<void> _inviaEMostraRisposta(String messaggio) async {
    // Invia messaggio all'API
    final risposta  = await _richiediRispostaDallApi(messaggio);

    // Aggiorna la chat con il messaggio inviato
    setState(() {
      _messaggiChat.add(messaggio);
      _controllerTesto.clear();
    });
    setState(() {
      _messaggiChat.add(risposta);
      _controllerTesto.clear();
    });
    // Attendi la risposta dall'API e aggiorna la chat con la risposta
    //final risposta = await _richiediRispostaDallApi();
    //setState(() {
    //  _messaggiChat.add(risposta);
    //});
  }

  Future<void> _inviaMessaggioAllApi(String messaggio) async {
    var url = 'http://localhost:8080/question'; // Sostituisci con l'URL del tuo server

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Specifica il tipo di contenuto come JSON
        },
        body: jsonEncode({
          'messaggio': messaggio,
        }),
      );

      if (response.statusCode != 200) {
        print('Errore durante l\'invio del messaggio. Codice: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore durante la richiesta HTTP: $e');
    }
  }


  Future<String> _richiediRispostaDallApi(String domanda) async {
    if (Uri == null){
      return 'Uri null';
    }
    //try {
      var url = Uri.parse('http://localhost:8080/question/$domanda'); // Sostituisci con l'URL del tuo server
      print(url);
      var response = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      }); //, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        // Assume che la risposta JSON contenga un campo specifico, ad esempio "risposta"
        final risposta = decodedResponse['question'];

        return 'Risposta ricevuta: $risposta';
      } else {
        return 'Errore durante la richiesta di risposta. Codice: ${response.statusCode}';
      }
    //} catch (e) {
    //  return 'Errore durante la richiesta HTTP: $e';
    //}
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
                        "Chat With Documents",
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
                                  Icon(isMessaggioUtente ? userIcon : responseIcon),
                                  SizedBox(width: 8), // Adjust the spacing between icon and text
                                  Text(
                                    _messaggiChat[index],
                                    style: TextStyle(fontSize: FONTSIZE),
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
                            style: ElevatedButton.styleFrom(primary: Colors.green),
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
                            style: ElevatedButton.styleFrom(primary: Colors.red),
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

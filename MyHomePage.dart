import 'package:docu_bot/Requests.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'costanti.dart';
import 'LabelDropDown.dart';
import 'SchermataChat.dart';
import 'ElencoFileCaricati.dart';


var _lingua = 'Italiano';
var _nomeModello = 'google/flan-t5-xxl';

class MyHomePage extends StatefulWidget {
  final String username = '';
  const MyHomePage({Key? key, required this.title, required username}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var _hasContent = false;
  var _fileSelezionato = -1;
  ElencoFileCaricati _elencoFileCaricati = ElencoFileCaricati();

  @override
  void initState() {
    super.initState();
    contaFilesGET().then((value) => _aggiornaElencoFiles(value));
  }

  void _aggiornaElencoFiles(files){
    setState(() {
      _elencoFileCaricati = ElencoFileCaricati.withFiles(files);
      _hasContent = (_elencoFileCaricati.contaFileCaricati > 0);
    });
  }

  // click carica nuovo file
  void _pickFile() async {
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles();

    if (resultFile != null) {
      bool aggiorna = await _elencoFileCaricati.salvaFile(resultFile);
      if(aggiorna){
        setState(() {
          _hasContent = (_elencoFileCaricati.contaFileCaricati > 0);
        });
      }
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
                        Container(
                          height: 45.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(BORDER_RADIUS),
                              ),
                            ),
                            onPressed: _pickFile,
                            child: const Text('Carica un file'),
                          ),
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
                            borderRadius: BorderRadius.circular(BORDER_RADIUS),
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

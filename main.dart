import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ElencoFileCaricati {
  List<String> _fileCaricati = [];

  void aggiungiFile(String nomeFile) {
    _fileCaricati.add(nomeFile);
  }

  List<String> get elencoCompleto => _fileCaricati;

  int get numeroFileCaricati => _fileCaricati.length;
}

List<String> _messaggiChat = []; // Dichiarazione della lista _messaggiChat

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
  final ElencoFileCaricati _elencoFileCaricati = ElencoFileCaricati(); // Aggiunta dell'oggetto ElencoFileCaricati

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String nomeFile = result.files.single.name;
      setState(() {
        _elencoFileCaricati.aggiungiFile(nomeFile); // Aggiunta del file all'elenco
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
                  LabelDropDown(etichetta: "Lingua", lista: 0, valoreDefault: 'Item 1', icona: Icons.flag),
                  const SizedBox(height: 20),
                  LabelDropDown(etichetta: "Modello", lista: 1, valoreDefault: 'Item 2', icona: Icons.mode_fan_off_rounded),
                  const SizedBox(height: 80), // Spazio tra il tuo bottone e l'elenco dei file

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Allineamento a sinistra
                    children: [
                      Icon(Icons.attach_file), // Icona "allega file"
                      const SizedBox(width: 8),
                      Text('Carica'), // Testo "Carica"
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _pickFile,
                        child: const Text('Carica un file'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Spazio tra il tuo bottone e l'elenco dei file
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 50, right: 50, bottom: 50), // Margine esterno di 50 pixel a sinistra, a destra e in basso
                      padding: const EdgeInsets.all(10), // Padding interno di 10 pixel
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black), // Bordo nero
                      ),
                      child: ListView.builder(
                        itemCount: _elencoFileCaricati.numeroFileCaricati, // Usa la lunghezza dell'elenco
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(Icons.insert_drive_file),
                            title: Text(_elencoFileCaricati.elencoCompleto[index]), // Ottieni il nome del file dall'elenco
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

class _StatoSchermataChat extends State<SchermataChat> {
  final TextEditingController _controllerTesto = TextEditingController();

  void _gestisciMessaggioInviato(String messaggio) {
    if (messaggio.isNotEmpty) {
      setState(() {
        _messaggiChat.add(messaggio);
        _controllerTesto.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 620,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top part with "Chat" text
                    const Text(
                      "Chat With Documents",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // Messaggi della chat
                    Expanded(
                      child: ListView.builder(
                        itemCount: _messaggiChat.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_messaggiChat[index]),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10), // Spazio a sinistra
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Inserisci la tua domanda",
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Spazio interno
                              ),
                              onSubmitted: _gestisciMessaggioInviato,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10), // Spazio tra l'input box e le icone
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(primary: Colors.green),
                          onPressed: () {
                            setState(() {
                              _gestisciMessaggioInviato(_controllerTesto.text);
                            });
                          },
                          icon: const Icon(Icons.send),
                          label: const Text("Invia"),
                        ),
                        const SizedBox(width: 10), // Spazio tra le icone
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          onPressed: () {
                            setState(() {
                              _messaggiChat.clear(); // Cancella tutti i messaggi
                            });
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Svuota Chat"),
                        ),
                        const SizedBox(width: 10), // Spazio tra le icone
                      ],
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
  final int lista;
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
            Text(widget.etichetta),
          ],
        ),
        const SizedBox(width: 5),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black38, width: 2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5), // Aggiungi spazio intorno alle Dropdown
            child: Container(
              width: 150,
              child: DropdownButton<String>(
                underline: Container(),
                value: widget.valoreDefault,
                onChanged: (String? newValue) {
                  setState(() {
                    widget.valoreDefault = newValue!;
                  });
                },
                isExpanded: true,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                items: <String>['Item 1', 'Item 2', 'Item 3', 'Item 4']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(
                      child: Text(value),
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

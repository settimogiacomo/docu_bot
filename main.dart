import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? dropdownValue1 = 'Item 1';
  String? dropdownValue2 = 'Option A';

  _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Eseguire le operazioni desiderate con il file selezionato
      print(result.files.single.name);
      print(result.files.single.path);
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
                  Row(
                    children: [
                      Icon(Icons.flag),
                      const SizedBox(width: 8),
                      const Text('Lingua'),
                      const SizedBox(width: 20),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white, //background color of dropdown button
                          border: Border.all(color: Colors.black38, width: 2), //border of dropdown button
                          borderRadius: BorderRadius.circular(50), //border radius of dropdown button
                        ),
                        child: Container(
                          width: 150,
                          child: DropdownButton<String>(
                            underline: Container(), // Rimuove la linea sotto il dropdown
                            value: dropdownValue1,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue1 = newValue;
                              });
                            },
                            isExpanded: true,
                            style:const TextStyle(
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
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.mode_fan_off_rounded),
                      const SizedBox(width: 8),
                      const Text('Modello'),
                      const SizedBox(width: 20),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white70, //background color of dropdown button
                          border: Border.all(color: Colors.black38, width: 2), //border of dropdown button
                          borderRadius: BorderRadius.circular(50), //border radius of dropdown button
                        ),
                        child: Container(
                          width: 150, // Imposta la larghezza desiderata
                          child: DropdownButton<String>(
                            underline: Container(), // Rimuove la linea sotto il dropdown
                            value: dropdownValue2,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue2 = newValue;
                              });
                            },
                            isExpanded: true,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            items: <String>['Option A', 'Option B', 'Option C', 'Option D']
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
                    ],
                  ),
                  const SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: ElevatedButton(
                            onPressed: _pickFile,
                            child: const Text('Carica un file'),
                          )
                      ),
                    ],
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Right Part'),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  FloatingActionButton(
                    onPressed: _incrementCounter,
                    tooltip: 'Increment',
                    child: Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
}

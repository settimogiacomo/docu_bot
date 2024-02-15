import 'dart:typed_data';

import 'costanti.dart';
import 'dart:convert'; //json
import 'package:http/http.dart' as http;


Future<bool> loginUtentePOST(String userName, String userPass) async {
  try {
    var url = Uri.parse('$SERVER/login');

    Map data = {'usr' : userName, 'pwd': userPass};
    var corpo = json.encode(data);
    http.Response response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: corpo);

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      bool risposta = decodedResponse['response'] == 'true';

      return risposta;
    } else {
      print('Errore durante la richiesta di risposta. Codice: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Errore durante la richiesta HTTP: $e');
    return false;
  }
}

  Future<List<String>> contaFilesGET()  async {
  try {
    var url = Uri.parse('$SERVER/files');
    http.Response response =  await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      var risposta = List<String>.from(decodedResponse['response'] as List);

      return risposta;
    } else {
      print('Errore durante la richiesta di risposta. Codice: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Errore durante la richiesta HTTP: $e');
    return [];
  }
}

Future<String> cambiaModelloPOST(String newModel) async {
  try {
    var url = Uri.parse('$SERVER/modello');

    Map data = {'modello_scelto' : newModel};
    var corpo = json.encode(data);
    http.Response response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: corpo);

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      // Assume che la risposta JSON contenga un campo specifico, ad esempio "risposta"
      final risposta = decodedResponse['response'];

      return risposta;
    } else {
      return 'Errore durante la richiesta di risposta. Codice: ${response.statusCode}';
    }
  } catch (e) {
    print('Errore durante la richiesta HTTP: $e');
    return 'Errore durante la richiesta HTTP: $e';
  }
}

Future<String> cambiaLinguaPOST(String newLanguage) async {
  try {
    var url = Uri.parse('$SERVER/lingua');
    print(url);
    Map data = {'lingua_scelta' : newLanguage};
    var corpo = json.encode(data);
    http.Response response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: corpo);

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      // Assume che la risposta JSON contenga un campo specifico, ad esempio "risposta"
      final risposta = decodedResponse['response'];

      return risposta;
    } else {
      return 'Errore durante la richiesta di risposta. Codice: ${response.statusCode}';
    }
  } catch (e) {
    print('Errore durante la richiesta HTTP: $e');
    return 'Errore durante la richiesta HTTP: $e';
  }
}

Future<String> ottieniRispostaPOST(String domanda) async {
  try {
    //Uri url = Uri.parse('https://dummyjson.com/todos');//http://localhost:8080/question/$domanda'); // Sostituisci con l'URL del tuo server
    var url = Uri.parse('$SERVER/question');
    print(url);
    Map data = {'domanda':domanda};
    var corpo = json.encode(data);
    http.Response response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: corpo);

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      // Assume che la risposta JSON contenga un campo specifico, ad esempio "risposta"
      final risposta = decodedResponse['response'];

      return risposta;
    } else {
      return 'Errore durante la richiesta di risposta. Codice: ${response.statusCode}';
    }
  } catch (e) {
    return 'Errore durante la richiesta HTTP: $e';
  }
}


Future<bool> inviaDocumentoPUT(Uint8List file, String nomeFile) async {
  try {
    // lettura file: lista di bytes
    int lunghezza = file.length;
    var url = Uri.parse('$SERVER/file/$nomeFile');
    print(url);
    http.Response response = await http.put(url, headers: {'Content-Type': 'text/plain', 'Content-Length': lunghezza.toString()}, body: file);

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      // Assume che la risposta JSON contenga un campo specifico, ad esempio "risposta"
      final String risposta = decodedResponse['response'];
      if (risposta.contains('esiste')){ // esiste già
        print(risposta);
        return false;
      } else {
        return true;
      }
      print(risposta);

    } else {
      print('Errore durante la richiesta di risposta. Codice: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Errore durante la richiesta HTTP: $e');
    return false;
  }
}
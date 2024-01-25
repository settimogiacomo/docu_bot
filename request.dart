import 'costanti.dart';
import 'dart:convert'; //json
import 'package:http/http.dart' as http;


Future<String> cambiaModello(newModel) async {
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

Future<String> cambiaLingua(newLanguage) async {
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

Future<String> ottieniRisposta(String domanda) async {
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
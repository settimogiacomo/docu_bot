import 'dart:typed_data';
import 'package:docu_bot/request.dart';
import 'package:file_picker/file_picker.dart';


class ElencoFileCaricati {
  List<String> _fileCaricati = []; //contaFilesHTTP();

  ElencoFileCaricati(){
    _fileCaricati = [];
  }

  ElencoFileCaricati.withFiles(List<String> lista){
    _fileCaricati = lista;
  }

  List<String> get elencoCompleto => _fileCaricati;
  int get contaFileCaricati => _fileCaricati.length;

  Future<bool> aggiungiFile(FilePickerResult file) async {

    try{
      String nomeFile = file.files.single.name;
      Uint8List? contentFile = file.files.single.bytes;

      bool resultHTTP = await inviaDocumentoHTTP(contentFile!, nomeFile);
      if (resultHTTP){
        _fileCaricati.add(nomeFile);
        return true;
      } else {
        print('qualcosa è andato storto durante il caricamento del file $nomeFile');
        return false;
      }
    }catch(ex){
      print(ex);
      return false;
    }

  }

}

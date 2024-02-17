import 'dart:async';
import 'package:docu_bot/request.dart';
import 'package:flutter/material.dart';
import 'MyHomePage.dart';
import 'costanti.dart';

// void main() {
//   runApp(LoginPage());
// }

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _selectedUser = 'Studente';
  String _selectedPassword = '';

  List<String> _users = ['Amministratore', 'Utente', 'Studente'];

  var _message = '';
  var _colorMessage = Colors.white;

  void _updateMessage(String message, Color color) {
    setState(() {
      _message = message;
      _colorMessage = color;
    });
  }

  Future<void> _login() async {
    _selectedUser = _selectedUser.trim();
    _selectedPassword = _selectedPassword.trim();
    if (_selectedPassword != '' && _selectedUser != ''){
      Future<bool> risposta = loginUtenteHTTP(_selectedUser,_selectedPassword);
      if (await risposta){
        _updateMessage('Credenziali corrette, stai per essere indirizzato alla pagina.', Colors.green);

        await Future.delayed(const Duration(seconds: 2));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'DocuBot', username: _selectedUser),
          ),
        );
      } else {
        _updateMessage('Username o password non validi', Colors.red);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:[
          Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 10.0),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black38, width: 1),
                borderRadius: BorderRadius.circular(BORDER_RADIUS),
              ),
              child: Padding(
                padding: const EdgeInsets.all(0.5),
                child: Container(
                  height: 45.0,
                  width: 230,
                  alignment: Alignment.center,
                  child: DropdownButton<String>(
                    value: _selectedUser,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedUser = newValue!;
                      });
                    },
                    isExpanded: true,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    underline: Container(), // Nasconde la linea sotto i nomi nel dropdown
                    items: _users.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: 230,
              padding: EdgeInsets.symmetric( vertical: 5.0),
              child: TextFormField(
                decoration:  InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(BORDER_RADIUS),
                  ),
                  filled: true, // Imposta il campo come riempito
                  fillColor: Colors.white, // Imposta il colore di riempimento
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _selectedPassword = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
            height: 45.0,
            width: 80.0,
            decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            border: Border.all(
            color: Colors.lightBlueAccent,
            ),
            borderRadius: BorderRadius.circular(BORDER_RADIUS)
            ),
            child: TextButton(
              style: ButtonStyle(iconColor: MaterialStateProperty.all(Colors.white)),
              onPressed: _login,
              child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 16.0,),),
            ),
            ),
            const SizedBox(height: 10.0),
            Text(
              _message,
              style: TextStyle(color: _colorMessage, fontSize: FONTSIZE),
            ),
        ],
      ),]
      ),
    );
  }
}


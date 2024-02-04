import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(LoginPage());
}

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
  String _selectedUser = 'Amministratore';
  String _selectedPassword = '';

  List<String> _users = ['Amministratore', 'Utente', 'Studente'];
  Map<String, String> _passwords = {
    'Amministratore': 'admin_password',
    'Utente': 'user_password',
    'Studente': 'student_password'
  };

  var _message = '';
  var _colorMessage = Colors.white;

  void _updateMessage(String message, Color color) {
    setState(() {
      _message = message;
      _colorMessage = color;
    });
  }

  void _login() {
    String password = _passwords[_selectedUser] ?? '';

    if (_selectedPassword == password) {
      // Login successful
      _updateMessage('Username e password corretti, stai per essere indirizzato alla pagina.', Colors.green);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SchermataChat(username: _selectedUser),
        ),
      );
    } else {
      // Login failed
      _updateMessage('Username o password non validi', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black38, width: 1),
              borderRadius: BorderRadius.circular(10.0),
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
                      _selectedPassword = _passwords[_selectedUser] ?? '';
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
            padding: EdgeInsets.symmetric(horizontal: 300.0, vertical: 5.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
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
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Login'),
          ),
          SizedBox(height: 10.0),
          Text(
            _message,
            style: TextStyle(color: _colorMessage),
          ),
        ],
      ),
    );
  }
}

class SchermataChat extends StatelessWidget {
  final String username;

  SchermataChat({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schermata Chat'),
      ),
      body: Center(
        child: Text('Benvenuto, $username'),
      ),
    );
  }
}

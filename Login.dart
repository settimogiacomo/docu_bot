import 'dart:async';
import 'package:docu_bot/SchermataChat.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: LoginForm(),
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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  String _selectedUser = 'Amministratore';

  List<String> _users = ['Amministratore', 'Utente', 'Studente'];

  void _login() {
    String password = _passwordController.text.trim();

    if ((_selectedUser == 'Amministratore' && password == 'admin_password') ||
        (_selectedUser == 'Utente' && password == 'user_password') ||
        (_selectedUser == 'Studente' && password == 'student_password')) {
      // Login successful
      setState(() {
        _errorMessage = 'Username e password corretti, stai per essere indirizzato alla pagina.';
      });

      // Delay di 5 secondi prima di navigare alla pagina successiva
     /* Future.delayed(Duration(seconds: 5), () {
        Navigator.push(
          context,
          Timer(const Duration(seconds: 2), ()=> Get.off(() => SchermataChat())),
        );
      });*/
    } else {
      // Login failed
      setState(() {
        _errorMessage = 'Username o password non validi';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Username',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButton<String>(
            value: _selectedUser,
            onChanged: (String? newValue) {
              setState(() {
                _selectedUser = newValue!;
              });
            },
            items: _users.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20.0),
          Text(
            'Password',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Enter your password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _login,
            child: Text('Login'),
          ),
          SizedBox(height: 10.0),
          Text(
            _errorMessage,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}

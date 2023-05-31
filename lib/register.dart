import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:project_prak_tpm/database_helper.dart';
import 'package:project_prak_tpm/login.dart';
import 'package:project_prak_tpm/user_model.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;

  final _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(Icons.login),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset(
                      'images/logo.png',
                      width: 180,
                      height: 180,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _username = value!;
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = _encryptPassword(value!);
                            },
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              _register();
                            },
                            child: Text('Register'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _encryptPassword(String password) {
    var bytes = utf8.encode(password); // Mengubah string password menjadi bytes
    var hashedPassword = sha256.convert(bytes); // Mengenkripsi bytes menggunakan algoritma SHA-256
    return hashedPassword.toString(); // Mengembalikan hasil enkripsi dalam bentuk string
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Check if the username already exists in the database
      final users = await _databaseHelper.getUsers();
      User? existingUser;

      try {
        existingUser = users.firstWhere((user) => user.username == _username);
      } catch (e) {
        print('Error: $e');
      }

      if (existingUser != null) {
        // Username already exists, show error message
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Registration Failed'),
                content: Text('Username already exists.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OKE'),
                  ),
                ],
              ),
        );
      } else {
        // Create a new user in the database
        final newUser = User(username: _username, password: _password);
        await _databaseHelper.insertUser(newUser);
        print('Encrypted Password: $_password');

        // Show success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registration Successful'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'User registered successfully.',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0), // Jarak antara teks
                  Text(
                    'Username: $_username',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Password: $_password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}
final auth = FirebaseAuth.instance;


class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายชื่อ Pokemon'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                        return Home();
                      }));
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [Text('auth.currentUser.email')],
      ),
    );
  }
}

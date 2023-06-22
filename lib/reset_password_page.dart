import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _auth = FirebaseAuth.instance;
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
            decoration: InputDecoration(
              labelText: "Email",
            ),
          ),
          ElevatedButton(
            child: Text('Reset Password'),
            onPressed: () async {
              try {
                await _auth.sendPasswordResetEmail(email: email);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password reset email sent')),
                );
              } on FirebaseAuthException catch (e) {
                print(e.message);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to send password reset email')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'pomodoro_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'add_task_page.dart';

class Task {
  String name;
  String description;
  int duration;
  String priority;

  Task({
    required this.name,
    required this.description,
    required this.duration,
    required this.priority,
  });
}

List<Task> taskList = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return PomodoroPage(user: snapshot.data!);
          }
          return LoginPage();
        },
      ),
      routes: {
        '/addTask': (context) => AddTaskPage(),
      },
    );
  }
}

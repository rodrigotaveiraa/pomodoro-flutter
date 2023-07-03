import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_task_page.dart';
import 'view_tasks_page.dart';
import 'main.dart';

class PomodoroPage extends StatelessWidget {
  final User user;

  PomodoroPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá ${user.displayName ?? user.email}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'lib/assets/images/tomato.png',
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'Bem-vindo ao Pomodoro App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Adicionar tarefa'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskPage()),
                );
              },
            ),
          ],
        ),
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width *
            0.8, // Define a largura do drawer
        child: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade400,
                  Colors.red.shade900
                ], // Cores do degradê
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color:
                        Colors.transparent, // Deixe o DrawerHeader transparente
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.add_box_outlined, color: Colors.white),
                  title: Text('Adicionar tarefa',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTaskPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.list, color: Colors.white),
                  title: Text('Ver tarefas',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ViewTasksPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.white),
                  title: Text('Sair', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

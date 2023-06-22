import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'pomodorotimer_page.dart';

class ViewTasksPage extends StatelessWidget {
  final CollectionReference tasksCollection =
  FirebaseFirestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Tarefas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: tasksCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar tarefas'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final taskDocuments = snapshot.data!.docs;

          taskList = taskDocuments.map((doc) {
            return Task(
              name: doc['name'],
              description: doc['description'],
              duration: doc['duration'],
              priority: doc['priority'],
            );
          }).toList();

          return ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              final task = taskList[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                child: Dismissible(
                  key: Key(task.name),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16.0),
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    tasksCollection.doc(taskDocuments[index].id).delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tarefa removida!')),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      task.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(task.description),
                    trailing: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PomodoroTimerPage(
                                pomodoroDuration: 1,
                                breakDuration: 5,
                                remainingPomodoros: task.duration,
                              ),
                            ),
                          );

                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String taskName = '';
  String taskDescription = '';
  int taskDuration = 1;
  String taskPriority = 'Baixa';

  List<String> priorities = ['Baixa', 'Média', 'Alta'];
  final CollectionReference tasksCollection =
  FirebaseFirestore.instance.collection('tasks');

  void registerTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Task newTask = Task(
        name: taskName,
        description: taskDescription,
        duration: taskDuration,
        priority: taskPriority,
      );

      await tasksCollection.add({
        'name': newTask.name,
        'description': newTask.description,
        'duration': newTask.duration,
        'priority': newTask.priority,
      });

      Fluttertoast.showToast(
        msg: 'Tarefa registrada!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(
        msg:
        'Falha ao registrar tarefa. Por favor, verifique os campos e tente novamente.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Tarefa'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Nome da Tarefa",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome da tarefa';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      taskName = value!;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Descrição da Tarefa",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a descrição da tarefa';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      taskDescription = value!;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Duração da Tarefa (em Pomodoros)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a duração da tarefa';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Por favor, insira um número válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      taskDuration = int.parse(value!);
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Prioridade da Tarefa",
                      border: OutlineInputBorder(),
                    ),
                    value: taskPriority,
                    items: priorities.map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        taskPriority = newValue!;
                      });
                    },
                    onSaved: (value) {
                      taskPriority = value!;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      child: Text('Registrar'),
                      onPressed: registerTask,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

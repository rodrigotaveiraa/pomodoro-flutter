import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Pomodoro()));
}

class Pomodoro extends StatefulWidget {
  @override
  _PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  double percent = 0;
  static int TimeInMinute = 25;
  int minute = 25;
  int seconds = 00;
  int TimeInSec = TimeInMinute * 60;
  bool startedPomodoro = false;
  TextEditingController _controller = TextEditingController();

  late Timer timer;

  void _StartTimer() {
    print("entrou aqui");
    startedPomodoro = true;
    print(seconds);
    int Time = TimeInMinute * 60;
    double SecPercent = (Time / 100);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print(seconds);
      setState(() {
        if (TimeInMinute > 0 || seconds > 0) {
          Time--;
          if (seconds == 0) {
            TimeInMinute--;
            seconds = 59;
          } else {
            seconds--;
          }
          if (Time % SecPercent == 0) {
            if (percent < 1) {
              percent += 0.01;
            } else {
              percent = 1;
            }
          }
        } else {
          percent = 0;
          TimeInMinute = 25;
          seconds = 0;
          timer.cancel();
        }
      });
    });
  }

  void _CancelPomodoro() {
    setState(() {
      startedPomodoro = false;
      percent = 0;
      TimeInMinute = minute;
      seconds = 0;
      timer.cancel();
    });
    print("cancelou");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('PomoLab'),
            backgroundColor: Colors.red,
            centerTitle: true,
          ),
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blueGrey, Colors.red],
                    begin: FractionalOffset(0.5, 1))),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                // Padding(
                //   padding: EdgeInsets.only(top: 5.0),
                //   child: Text("PomoLab",
                //       style: TextStyle(color: Colors.white, fontSize: 30.0)),
                // ),
                Expanded(
                    // flex: 2,
                    child: CircularPercentIndicator(
                        percent: percent,
                        animation: true,
                        animateFromLastPercent: true,
                        radius: 130.0,
                        lineWidth: 10.0,
                        progressColor: Colors.white,
                        center: GestureDetector(
                          onTap: () {
                            if (seconds == 0) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Insira tempo de tarefa'),
                                    content: Form(
                                      child: TextFormField(
                                        controller: _controller,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            TimeInMinute =
                                                int.parse(_controller.text);
                                            minute =
                                                int.parse(_controller.text);
                                          });
                                          Navigator.of(context).pop();
                                          _controller.clear();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red),
                                          padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 15.0),
                                          ),
                                        ),
                                        child: Text('Confirmar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text(
                            seconds < 10
                                ? "${TimeInMinute}:0${seconds}"
                                : "${TimeInMinute}:${seconds}",
                            style:
                                TextStyle(color: Colors.white, fontSize: 80.0),
                          ),
                        ))),
                SizedBox(height: 43.0),
                Expanded(
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30.0),
                                topLeft: Radius.circular(30.0))),
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: 30.0, left: 20.0, right: 20.0),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                    child: Row(children: <Widget>[
                                  Expanded(
                                    child: Column(children: <Widget>[
                                      Text(
                                        "Work Timer",
                                        style: TextStyle(fontSize: 25.0),
                                      ),
                                      SizedBox(height: 10.0),
                                      Text("${minute}",
                                          style: TextStyle(fontSize: 80))
                                    ]),
                                  ),
                                  Expanded(
                                    child: Column(children: <Widget>[
                                      Text(
                                        "Pause Timer",
                                        style: TextStyle(fontSize: 25.0),
                                      ),
                                      SizedBox(height: 10.0),
                                      Text("5", style: TextStyle(fontSize: 80))
                                    ]),
                                  )
                                ])),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 28.0),
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red),
                                          padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 30.0),
                                          ),
                                        ),
                                        child: !startedPomodoro
                                            ? Text("Start Pomodoro")
                                            : Text("Stop Pomodoro"),
                                        onPressed: !startedPomodoro
                                            ? _StartTimer
                                            : _CancelPomodoro)),
                              ],
                            ))))
              ],
            ),
          )),
    );
  }
}

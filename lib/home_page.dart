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
  int TimeInSec = TimeInMinute * 60;
  int seconds = 00;
  bool startedPomodoro = false;
  Timer? timer;

  TextEditingController _controller = TextEditingController();

  void _StartTimer() {
    startedPomodoro = true;
    int Time = TimeInMinute * 60;
    double SecPercent = (Time / 100);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (Time > 0) {
          Time--;
          if (Time % 60 == 0) {
            TimeInMinute--;
          }
          if (Time % SecPercent == 0) {
            if (percent < 1) {
              percent += 0.01;
            } else {
              percent = 1;
            }
          }
          seconds = Time % 60;
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
      TimeInMinute = 25;
      seconds = 0;
      if (timer != null) {
        timer!.cancel();
      }
    });
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
        backgroundColor: Colors.red[100],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/tomato.png',
                height: 250,
              ),
              Text(
                'Bem-vindo ao Pomodoro App!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Aumente sua produtividade com a técnica Pomodoro',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Expanded(
                child: CircularPercentIndicator(
                  percent: percent,
                  animation: true,
                  animateFromLastPercent: true,
                  radius: 200.0,
                  lineWidth: 20.0,
                  progressColor: Colors.red,
                  center: Text(
                    "${TimeInMinute}:${seconds < 10 ? '0$seconds' : '$seconds'}",
                    style: TextStyle(color: Colors.black, fontSize: 50.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: !startedPomodoro ? _StartTimer : _CancelPomodoro,
                    child: !startedPomodoro
                        ? Icon(Icons.play_arrow)
                        : Icon(Icons.stop),
                    backgroundColor: !startedPomodoro ? Colors.green : Colors.red,
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

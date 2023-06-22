import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PomodoroTimerPage extends StatefulWidget {
  final int pomodoroDuration;
  final int breakDuration;
  int remainingPomodoros;

  PomodoroTimerPage({
    required this.pomodoroDuration,
    required this.breakDuration,
    required this.remainingPomodoros,
  });

  @override
  _PomodoroTimerPageState createState() => _PomodoroTimerPageState();
}

class _PomodoroTimerPageState extends State<PomodoroTimerPage> {
  double percent = 0;
  int totalTime = 0;
  int timeInSec = 0;
  int minutes = 0;
  int seconds = 0;
  Timer? timer;
  bool isPomodoro = true;
  bool isTimerRunning = false;
  bool isBreak = false;

  @override
  void initState() {
    super.initState();
    totalTime = widget.pomodoroDuration;
    timeInSec = totalTime * 60;
  }

  int getTotalTime() {
    return isPomodoro ? widget.pomodoroDuration : widget.breakDuration;
  }

  void showNotification(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void startTimer() {
    setState(() {
      isTimerRunning = true;
    });

    int time = getTotalTime() * 60;
    double secPercent = (time / 100);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (time > 0) {
          time--;
          minutes = time ~/ 60;
          seconds = time % 60;
          if (time % secPercent == 0) {
            if (percent < 1) {
              percent += 0.01;
              if (percent > 1) {
                percent = 1;
              }
            } else {
              percent = 1;
            }
          }
        } else {
          percent = 0;
          timer.cancel();
          if (isPomodoro) {
            isPomodoro = false;
            totalTime = widget.breakDuration;
            isBreak = true;
            showNotification("Fim do Pomodoro", "Hora do intervalo!");
          } else {
            isPomodoro = true;
            totalTime = widget.pomodoroDuration;
            isBreak = false;
            showNotification("Fim do Intervalo", "Hora de trabalhar!");
            if (widget.remainingPomodoros > 0) {
              widget.remainingPomodoros--;
            }
          }
          startTimer();
        }
      });
    });
  }

  void cancelTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    setState(() {
      percent = 0;
      isPomodoro = true;
      isBreak = false;
      totalTime = widget.pomodoroDuration;
      minutes = totalTime;
      seconds = 0;
      isTimerRunning = false;
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Image.asset(
                'lib/assets/images/tomato.png',
                height: 120,
              ),
              Text(
                'Pomodoro Timer',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: CircularPercentIndicator(
                  percent: percent,
                  animation: true,
                  animateFromLastPercent: true,
                  radius: 200.0,
                  lineWidth: 20.0,
                  progressColor: isBreak ? Colors.green : Colors.red,
                  center: Text(
                    "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                    style: TextStyle(color: Colors.black, fontSize: 50.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: isTimerRunning ? cancelTimer : startTimer,
                    child: Icon(
                      isTimerRunning ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Pomodoros restantes: ${widget.remainingPomodoros}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

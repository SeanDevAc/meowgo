// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:meowgo/component/db_helper.dart';
import 'dart:async';
import '../main-views/settings-page-widget.dart';
import 'package:pedometer/pedometer.dart';
import '../main-views/step_count_page.dart';
import '../main-views/got_egg_page.dart';

class TimerStatefulWidget extends StatefulWidget {
  const TimerStatefulWidget({super.key});

  @override
  State<TimerStatefulWidget> createState() => _TimerWidget();
}

class _TimerWidget extends State<TimerStatefulWidget> {
  //init stopwatch instance
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;

  Duration _duration = const Duration(minutes: 0);
  String _result = "01:00";
  bool _isRunning = false;

  void _start() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      //setState voor UI update
      setState(() {
        //format result
        if (_duration.inSeconds > 0) {
          _duration = _duration - const Duration(seconds: 1);
          _result =
              '${_duration.inMinutes.toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}';
        } else {
          _stop();
          _enoughTimeElapsed();
        }
      });
    });
    _stopwatch.start();
  }

  void _stop() {
    setState(() {
      _isRunning = false;
    });
    _timer.cancel();
    _stopwatch.stop();
  }

  void _enoughTimeElapsed() {
    Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return StepCountPage();
      },
    ));

    _resetTimer(_duration);
  }

  void _resetTimer(duration) {
    print("object");
    setState(() {
      _duration = duration;
      _result =
          '${_duration.inMinutes.toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: startStopButton(),
    );
  }

  TextButton startStopButton() => TextButton(
      onPressed: _isRunning ? _stop : _start,
      style: ButtonStyle(
          minimumSize: const MaterialStatePropertyAll(Size(90, 40)),
          backgroundColor: _isRunning
              ? const MaterialStatePropertyAll<Color>(Colors.redAccent)
              : const MaterialStatePropertyAll<Color>(Colors.green),
          foregroundColor: const MaterialStatePropertyAll<Color>(Colors.white)),
      child: Text(_result) //dit is voor de tijd zelf, hieronder is play/pause
      // Icon(_isRunning ? Icons.pause : Icons.play_arrow)
      );
}

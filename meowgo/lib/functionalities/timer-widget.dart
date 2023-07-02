// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:meowgo/component/db_helper.dart';
import 'dart:async';
import '../main-views/settings-page-widget.dart';
import 'package:pedometer/pedometer.dart';
import '../main-views/step_count_page.dart';
import '../main-views/got_egg_page.dart';
import '../main-views/got_new_pokemon_page.dart';

class TimerStatefulWidget extends StatefulWidget {
  const TimerStatefulWidget({super.key});

  @override
  State<TimerStatefulWidget> createState() => _TimerWidget();
}

class _TimerWidget extends State<TimerStatefulWidget> {
  //init stopwatch instance
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;

  final Duration _targetDuration = const Duration(seconds: 1);
  Duration _duration = const Duration(seconds: 1);
  String _result = "01:00";
  bool _isRunning = false;

  int totalSteps = 0;

  bool isHatchingEgg = false;

  void _hatchingChoiceDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Which one?'),
            content: const Text('Find or hatch?'),
            actions: [
              TextButton(
                  onPressed: () {
                    isHatchingEgg = false;
                    _start();
                    Navigator.pop(context);
                  },
                  child: const Text('Find')),
              TextButton(
                  onPressed: () {
                    isHatchingEgg = true;
                    _start();
                    Navigator.pop(context);
                  },
                  child: const Text('Hatch'))
            ],
          );
        });
  }

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
          _enoughTimeElapsed();
          _stop();
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

  void openStepCounter() async {
    final totalStepsObject = await Navigator.pushNamed(
      context,
      '/stepCountPage',
      arguments: {'totalSteps': totalSteps},
    );
    totalSteps = totalStepsObject as int;
  }

  void _enoughTimeElapsed() {
    _resetTimer(_targetDuration);
    print('enough time');

    !isHatchingEgg ? openStepCounter() : openGotNewPokemonPage();
  }

  void openGotNewPokemonPage() {
    Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return const gotNewPokemonPage();
        // return GotEggPage();
      },
    ));
  }

  void _resetTimer(Duration duration) {
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
      onPressed: _isRunning ? _stop : _hatchingChoiceDialog,
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

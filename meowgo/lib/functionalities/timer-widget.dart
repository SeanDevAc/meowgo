import 'package:flutter/material.dart';
import 'dart:async';

class TimerStatefulWidget extends StatefulWidget {
  const TimerStatefulWidget({super.key});

  @override
  State<TimerStatefulWidget> createState() => _TimerWidget();
}

class _TimerWidget extends State<TimerStatefulWidget> {
  //init stopwatch instance
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;

  String _result = '00:00:00';

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      //setState voor UI update
      setState(() {
        //format result
        _result =
            '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
      });
    });
    _stopwatch.start();
  }

  void _stop() {
    _timer.cancel();
    _stopwatch.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Text(_result),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: _start, child: const Text('start')),
            ],
          )
        ],
      )),
    );
  }
}

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
  final timeNeeded = 5;

  String _result = '00:00';
  bool _isRunning = false;

  void _start() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 1000), (Timer t) {
      //setState voor UI update
      setState(() {
        //format result
        _result =
            '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
        if (_stopwatch.elapsed.inSeconds % timeNeeded == 0) {
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
    print('hoi');
// als wekkerfunctie aanstaat, komt er een wekker en 10 creds erbij
// als silent aanstaat, krijg je gewoon 10 creds erbij. timer gaat door
//
  }

  @override
  Widget build(BuildContext context) {
    return timerView();
  }

  Row timerView() {
    return Row(children: [
      Text(
        _result,
        // style: TextStyle(
        //     color: Color.fromARGB(0, 240, 5, 5),
        //     backgroundColor: Color.fromARGB(245, 243, 3, 3)),
      ),
      const SizedBox(
        width: 10,
      ),
      startStopButton(),
    ]);
  }

  ElevatedButton startStopButton() => ElevatedButton(
      onPressed: _isRunning ? _stop : _start,
      style: ButtonStyle(
          backgroundColor: _isRunning
              ? const MaterialStatePropertyAll<Color>(Colors.redAccent)
              : const MaterialStatePropertyAll<Color>(Colors.green),
          foregroundColor: const MaterialStatePropertyAll<Color>(Colors.white)),
      child: Text(
        _isRunning ? 'pause' : 'start',
      ));
}

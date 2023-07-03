// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:meowgo/pokemon_helpers/db_helper.dart';
import 'dart:async';

import '../pop_up_views/got_new_pokemon_page.dart';

class TopAppBarTimerWidget extends StatefulWidget
    implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  const TopAppBarTimerWidget({super.key});

  @override
  State<TopAppBarTimerWidget> createState() => _TopAppBarWidgetState();
}

class _TopAppBarWidgetState extends State<TopAppBarTimerWidget> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;

  final Duration _targetDuration = const Duration(seconds: 3);
  Duration _duration = const Duration(seconds: 3);
  String _result = "Study!";
  bool _isRunning = false;

  int totalSteps = 0;

  bool isHatchingEgg = false;
  int eggsAmount = 0;

  bool active = false;

  @override
  void initState() {
    super.initState();
    eggsAmount = 0;
  }

  void _hatchingChoiceDialog() {
    checkEggs();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Which one?'),
            content: Text('Find or hatch? Eggs: $eggsAmount'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    isHatchingEgg = false;
                    active = true;
                    _start();
                    Navigator.pop(context);
                  },
                  child: const Text('Find')),
              ElevatedButton(
                  onPressed: eggsAmount > 0
                      ? () {
                          isHatchingEgg = true;
                          active = true;
                          _start();
                          Navigator.pop(context);
                        }
                      : null,
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
      setState(() {
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
    DatabaseHelper().addEggs(1);
    await Navigator.pushNamed(
      context,
      '/stepCountPage',
    );
  }

  void _enoughTimeElapsed() {
    _resetTimer(_targetDuration);
    active = false;
    print('enough time');
    !isHatchingEgg ? openStepCounter() : openGotNewPokemonPage();
  }

  void openGotNewPokemonPage() {
    DatabaseHelper().addEggs(-1);
    Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return const GotNewPokemonPage();
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

  Future<void> checkEggs() async {
    int result = await DatabaseHelper().getEggAmount();
    setState(() {
      eggsAmount = result;
    });
  }

  List<Widget> eggsBar() {
    checkEggs();
    int amount = eggsAmount;
    List<Widget> result = [];

    if (amount > 4) {
      result.add(Row(
        children: [
          const Icon(
            Icons.egg,
            color: Color.fromARGB(149, 255, 255, 255),
            size: 28,
          ),
          Text(
            '$amount',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromARGB(255, 255, 252, 252)),
          ),
        ],
      ));
    } else if (amount <= 0) {
      result.add(const Text(
        'No eggs!',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color.fromARGB(152, 255, 252, 252)),
      ));
    } else {
      for (var i = amount; i > 0; i--) {
        result.add(const Row(children: [
          Icon(
            Icons.egg,
            color: Color.fromARGB(192, 255, 255, 255),
            size: 24,
          )
        ]));
      }
    }
    result.add(const SizedBox(
      width: 10,
    ));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 41, 42, 42),
      leadingWidth: 90,
      leading: Padding(
        padding: const EdgeInsets.all(7.0),
        child: startStopButton(),
      ),
      actions: [
        Row(
          children: eggsBar(),
        )
      ],
      title: active
          ? Card(
              color: isHatchingEgg ? Colors.yellow : Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isHatchingEgg ? Icons.egg : Icons.search,
                      color: isHatchingEgg ? Colors.black : Colors.white,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      isHatchingEgg ? 'Hatching...' : 'Searching...',
                      style: TextStyle(
                        color: isHatchingEgg ? Colors.black : Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Text(
              'Idle',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
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
      child: Text(_result));
}

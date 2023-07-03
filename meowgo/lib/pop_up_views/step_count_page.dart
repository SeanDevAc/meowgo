import 'package:flutter/material.dart';
import 'package:meowgo/pokemon_helpers/db_helper.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';

import '../pokemon_helpers/pokemon_widget.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class StepCountPage extends StatefulWidget {
  const StepCountPage({super.key});

  @override
  State<StepCountPage> createState() => _StepCountPageState();
}

class _StepCountPageState extends State<StepCountPage> {
  late Stream<StepCount> _stepCountStream;
  String _stepsString = '?';
  final int targetSteps = 20;
  int totalSteps = 0;
  int _currentSteps = 0;

  bool isFirstRun = true;
  bool enoughSteps = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    if ((isFirstRun && mounted && !enoughSteps)) {
      totalSteps = event.steps;
      // print('total steps initialized: $totalSteps');
      setState(() {
        isFirstRun = false;
      });
    }

    if (!mounted) {
      totalSteps = event.steps;
      // print('not mounted');
      return;
    }
    setState(() {
      //grootste getal vanuit event - wat het meekrijgt uit prev
      _currentSteps = event.steps - totalSteps;
      _stepsString = _currentSteps.toString();
    });

    if (_currentSteps >= targetSteps) {
      // print('current: $_currentSteps\ntotal: $totalSteps');
      enoughStepsTaken();
    }
  }

  void enoughStepsTaken() {
    enoughSteps = true;
    isFirstRun = true;
  }

  void goBackWithEgg(bool gotEgg) {
    if (gotEgg) {
      DatabaseHelper().addEggs(1);
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
    isFirstRun = true;
  }

  void onStepCountError(error) {
    // print('onStepCountError: $error');
    if (!mounted) return;
    setState(() {
      _stepsString = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 42, 42),
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              goBackWithEgg(false);
            },
          ),
          backgroundColor: Colors.redAccent,
          title: const Text('Nice!'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                "Take $targetSteps steps to get an extra egg!",
                style: const TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Steps Taken',
                style: TextStyle(fontSize: 26, color: Colors.white),
              ),
              Text(
                _stepsString,
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        heightFactor: 0.5,
                        child: FutureBuilder(
                          future: DatabaseHelper().getActivePokemon(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text(
                                  'An error occured while loading the pokemon');
                            } else if (snapshot.hasData) {
                              return PokemonWidget(pokemon: snapshot.data!);
                            } else {
                              return const Text('No pokemon is following you');
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            enoughSteps
                                ? Colors.greenAccent
                                : Colors.redAccent),
                        foregroundColor: MaterialStatePropertyAll<Color>(
                            enoughSteps ? Colors.black : Colors.white)),
                    onPressed: () => enoughSteps
                        ? goBackWithEgg(enoughSteps)
                        : goBackWithEgg(enoughSteps),
                    child: Text(enoughSteps
                        ? 'Receive egg!'
                        : 'no thanks, take me home')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

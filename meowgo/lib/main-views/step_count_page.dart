import 'package:flutter/material.dart';
import 'package:meowgo/component/db_helper.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class StepCountPage extends StatefulWidget {
  const StepCountPage({super.key});

  @override
  _StepCountPageState createState() => _StepCountPageState();
}

class _StepCountPageState extends State<StepCountPage> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _stepsString = '?';
  final int targetSteps = 10;
  int totalSteps = 0;
  int prevSteps = 0;
  int _currentSteps = 0;

  bool isFirstRun = true;
  bool mustBeInitialized = true;
  bool enoughSteps = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    if ((isFirstRun && mounted && !enoughSteps)) {
      totalSteps = event.steps;
      print('total steps initialized: $totalSteps');
      setState(() {
        isFirstRun = false;
      });
    }
    if (mustBeInitialized) {
      setState(() {
        totalSteps = event.steps;
        print('INIT RAN: $totalSteps');
        mustBeInitialized = false;
      });
    }
    // als dit in de achtergrond runt:
    if (!mounted) {
      totalSteps = event.steps;
      print('not mounted');
      return;
    }
    // totalSteps hier op first run op 0 for some reason
    print('evensteps: ${event.steps}\n totalSteps: $totalSteps');
    setState(() {
      //grootste getal vanuit event - wat het meekrijgt uit prev
      _currentSteps = event.steps - totalSteps;
      _stepsString = _currentSteps.toString();
    });

    if (_currentSteps > targetSteps) {
      // setStepsAmount(event.steps);
      print('current: $_currentSteps\ntotal: $totalSteps');
      enoughStepsTaken();
    }
  }

  void enoughStepsTaken() {
    enoughSteps = true;
    isFirstRun = true;
  }

  void goBackWithEgg(bool gotEgg) {
    if (gotEgg) {
      //iets met ei erbij
    } else {}
    isFirstRun = true;
    Navigator.pop(context, totalSteps + _currentSteps);
  }

  void updateTotalSteps(StepCount event) {
    totalSteps = event.steps;
  }

  // Future<int> getStepsAmount() async {
  //   stepsAmount = await DatabaseHelper().getStepsAmount();
  //   return stepsAmount;
  // }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    if (!mounted) {
      return;
    } else {}
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    if (!mounted) return;
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    if (!mounted) return;
    setState(() {
      _stepsString = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final prev =
        (ModalRoute.of(context)?.settings.arguments ?? <int, dynamic>{}) as Map;
    prevSteps = prev['totalSteps'];
    if (prevSteps != 0) {
      totalSteps = prevSteps;
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context, totalSteps + _currentSteps);
            },
          ),
          title: const Text('Congrats!'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "You got an egg!\nnow take $targetSteps steps for another egg!",
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 60,
              ),
              const Text(
                'Steps Taken',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                _stepsString,
                style: const TextStyle(fontSize: 60),
              ),
              const Divider(
                height: 100,
                thickness: 0,
                color: Colors.white,
              ),
              const Text(
                'Pokemon Status',
                style: TextStyle(fontSize: 30),
              ),
              Icon(
                _status == 'walking' ? Icons.egg : Icons.catching_pokemon,
                size: 100,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: enoughSteps
                        ? () {
                            Navigator.pop(context, totalSteps + _currentSteps);
                          }
                        : null,
                    child: const Text('Receive egg!')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

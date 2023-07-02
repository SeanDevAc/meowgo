import 'package:flutter/material.dart';
import 'package:meowgo/component/db_helper.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';

import '../component/pokemonwidget.dart';

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
      // print('total steps initialized: $totalSteps');
      setState(() {
        isFirstRun = false;
      });
    }
    if (mustBeInitialized) {
      setState(() {
        totalSteps = event.steps;
        // print('INIT RAN: $totalSteps');
        mustBeInitialized = false;
      });
    }
    // als dit in de achtergrond runt:
    if (!mounted) {
      totalSteps = event.steps;
      // print('not mounted');
      return;
    }
    // totalSteps hier op first run op 0 for some reason
    // print('evensteps: ${event.steps}\n totalSteps: $totalSteps');
    setState(() {
      //grootste getal vanuit event - wat het meekrijgt uit prev
      _currentSteps = event.steps - totalSteps;
      _stepsString = _currentSteps.toString();
    });

    if (_currentSteps >= targetSteps) {
      // setStepsAmount(event.steps);
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
      //iets met ei erbij
      DatabaseHelper().addEggs(1);
    } else {}
    Navigator.of(context).popUntil((route) => route.isFirst);
    // Navigator.popUntil(context, ModalRoute.withName('/home'));
    isFirstRun = true;
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
    // print('onPedestrianStatusError: $error');
    if (!mounted) return;
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    // print(_status);
  }

  void onStepCountError(error) {
    // print('onStepCountError: $error');
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
    // final prev =
    //     (ModalRoute.of(context)?.settings.arguments ?? <int, dynamic>{}) as Map;
    // prevSteps = prev['totalSteps'];
    // if (prevSteps != 0) {
    //   totalSteps = prevSteps;
    // }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              goBackWithEgg(false);
            },
          ),
          title: const Text('Congrats!'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                "You got an egg!\nnow take $targetSteps steps for another egg!",
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Steps Taken',
                style: TextStyle(fontSize: 26),
              ),
              Text(
                _stepsString,
                style: const TextStyle(fontSize: 40),
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
              // Icon(
              //   _status == 'walking' ? Icons.egg : Icons.catching_pokemon,
              //   size: 100,
              // ),
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
                        : 'no thanks, take me back')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

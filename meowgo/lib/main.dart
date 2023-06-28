import 'dart:async';
import 'package:flutter/material.dart';

import 'settings-page-widget.dart';
import 'eggdex-page-widget.dart';

void main() {
  runApp(const StudyMonApp());
}

class StudyMonApp extends StatelessWidget {
  const StudyMonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(174, 255, 15, 15))),
      home: const StudyMonStatefulWidget(),
    );
  }
}

class StudyMonStatefulWidget extends StatefulWidget {
  const StudyMonStatefulWidget({super.key});

  @override
  State<StudyMonStatefulWidget> createState() => _StudyMonState();
}

class TimerStatefulWidget extends StatefulWidget {
  const TimerStatefulWidget({super.key});

  @override
  State<TimerStatefulWidget> createState() => _TimerWidget();
}

class _StudyMonState extends State<StudyMonStatefulWidget> {
  int currentPageIndex = 0;
  var pages = <Text>[
    const Text("Current session"),
    const Text("Egg-Dex"),
    const Text("Settings & Stats"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: pages[currentPageIndex],
        // backgroundColor: ,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.egg),
            label: 'Egg-Dex',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Stats',
          ),
        ],
      ),
      body: <Widget>[
        const HomePageWidget(),
        const EggDexWidget(),
        const SettingsStatsWidget(),
      ][currentPageIndex],
    );
  }
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return const Scaffold();

    // Container(
    //   color: theme.colorScheme.inversePrimary,
    //   alignment: Alignment.center,

    //   // child: const Text('Page 1'),
  }
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

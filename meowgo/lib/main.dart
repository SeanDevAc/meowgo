import 'dart:ffi';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              seedColor: Color.fromARGB(176, 255, 15, 15))),
      home: const StudyMonStatefulWidget(),
    );
  }
}

class StudyMonStatefulWidget extends StatefulWidget {
  const StudyMonStatefulWidget({super.key});

  @override
  State<StudyMonStatefulWidget> createState() => _StudyMonState();
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
    return Container(
      color: theme.colorScheme.inversePrimary,
      alignment: Alignment.center,
      child: const Text('Page 1'),
    );
  }
}

class EggDexWidget extends StatelessWidget {
  const EggDexWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.inversePrimary,
      alignment: Alignment.center,
      child: const Text('Page 2'),
    );
  }
}

class SettingsStatsWidget extends StatelessWidget {
  const SettingsStatsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.inversePrimary,
      alignment: Alignment.center,
      child: const Text('Page 3'),
    );
  }
}

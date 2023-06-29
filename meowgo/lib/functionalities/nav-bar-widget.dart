import 'dart:async';
import 'package:flutter/material.dart';

import './timer-widget.dart';

import '../main-views/home-page-widget.dart';
import '../main-views/settings-page-widget.dart';
import '../main-views/eggdex-page-widget.dart';

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
        title: const Row(
          children: [TimerStatefulWidget()],
        ),
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

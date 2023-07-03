import 'package:flutter/material.dart';

import 'top_app_bar_timer_widget.dart';

import '../main_views/home_page_widget.dart';
import '../main_views/settings_page_widget.dart';
import '../main_views/dex_page_widget.dart';

class StudyMonNav extends StatefulWidget {
  const StudyMonNav({Key? key}) : super(key: key);

  @override
  State<StudyMonNav> createState() => _StudyMonNavState();
}

class _StudyMonNavState extends State<StudyMonNav> {
  @override
  void initState() {
    super.initState();
  }

  int currentPageIndex = 1;

  var pages = <Text>[
    const Text("Party"),
    const Text("Pokédex"),
    const Text("Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBarTimerWidget(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        currentIndex: currentPageIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon),
            label: 'Pokédex',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        const HomePageWidget(),
        const DexWidget(),
        const SettingsWidget(),
      ][currentPageIndex],
    );
  }
}

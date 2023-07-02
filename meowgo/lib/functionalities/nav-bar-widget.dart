import 'package:flutter/material.dart';
import 'package:meowgo/component/db_helper.dart';
import 'package:meowgo/functionalities/pokemonAPI-widget.dart';

import './timer-widget.dart';

import '../main-views/home-page-widget.dart';
import '../main-views/settings-page-widget.dart';
import '../main-views/eggdex_page_widget.dart';
import '../component/db_helper.dart';

class StudyMonStatefulWidget extends StatefulWidget {
  const StudyMonStatefulWidget({Key? key}) : super(key: key);

  @override
  State<StudyMonStatefulWidget> createState() => _StudyMonState();
}

class _StudyMonState extends State<StudyMonStatefulWidget> {
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
      appBar: TimerStatefulWidget(),
      // AppBar(
      //   //title: pages[currentPageIndex],
      //   leading: const TimerStatefulWidget(),
      //   leadingWidth: 2000.0,
      // ),
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
        const HomePage(),
        const EggDexWidget(),
        const SettingsStatsWidget(),
      ][currentPageIndex],
    );
  }
}

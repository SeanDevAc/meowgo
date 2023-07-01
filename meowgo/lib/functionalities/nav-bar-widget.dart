import 'package:flutter/material.dart';
import 'package:meowgo/component/db_helper.dart';
import 'package:meowgo/functionalities/egg_counter_widget.dart';
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
    DatabaseHelper().nukeDatabase();
    PokeApiWidget.fetchAllPokemon();
  }

  int currentPageIndex = 1;
  var pages = <Text>[
    const Text("Party"),
    const Text("Egg-Dex"),
    const Text("Settings & Stats"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: pages[currentPageIndex],
        leading: const TimerStatefulWidget(),
        leadingWidth: 80.0,
        actions: const [EggCounterStateful()],
      ),
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
            icon: Icon(Icons.egg),
            label: 'Egg-Dex',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Stats',
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

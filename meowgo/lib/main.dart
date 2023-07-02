import 'package:flutter/material.dart';
import 'package:meowgo/main-views/got_new_pokemon_page.dart';
import 'package:meowgo/main-views/start_page_widget.dart';
import 'package:meowgo/main-views/step_count_page.dart';

import 'functionalities/nav-bar-widget.dart';

void main() {
  runApp(
    const StudyMonApp(),
  );
}

class StudyMonApp extends StatelessWidget {
  const StudyMonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named routes i think?',
      routes: {
        '/stepCountPage': (context) => const StepCountPage(),
        '/hatchedPokemonPage': (context) => const GotNewPokemonPage(),
        '/home': (context) => const StudyMonStatefulWidget()
      },
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(172, 255, 38, 38))),
      home: const StartPageWidget(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:meowgo/pop_up_views/got_new_pokemon_page.dart';
import 'package:meowgo/pop_up_views/splash_page_widget.dart';
import 'package:meowgo/pop_up_views/step_count_page.dart';

import 'nav_bars/studymon_bottom_nav_widget.dart';

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
        '/home': (context) => const StudyMonNav()
      },
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(172, 255, 38, 38))),
      home: const SplashPageWidget(),
    );
  }
}

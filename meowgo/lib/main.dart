import 'package:flutter/material.dart';
import 'package:meowgo/main-views/home-page-widget.dart';
import 'package:meowgo/main-views/step_count_page.dart';
import 'package:path/path.dart';

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
      routes: {'/stepCountPage': (context) => const StepCountPage()},
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(174, 255, 15, 15))),
      home: const StudyMonStatefulWidget(),
    );
  }
}

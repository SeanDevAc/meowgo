import 'package:flutter/material.dart';

import 'functionalities/nav-bar-widget.dart';

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
              seedColor: Color.fromARGB(172, 255, 38, 38))),
      home: const StudyMonStatefulWidget(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:meowgo/functionalities/nav-bar-widget.dart';
import 'package:meowgo/main-views/home-page-widget.dart';
import 'package:meowgo/main-views/step_count_page.dart';

class StartPageWidget extends StatefulWidget {
  const StartPageWidget({Key? key}) : super(key: key);

  @override
  State<StartPageWidget> createState() => _StartPageState();
}

class _StartPageState extends State<StartPageWidget> {
  @override
  Widget build(BuildContext context) {
    final gradientColors = [
      Colors.red,
      Colors.red,
      Colors.white,
      Colors.white,
    ];
    final stops = [0.0, 0.5, 0.5, 1.0];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
          stops: stops,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Start Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the Start Page!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return const StudyMonStatefulWidget();
                      },
                    ),
                  );
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

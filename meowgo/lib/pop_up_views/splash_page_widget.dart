import 'package:flutter/material.dart';
import 'package:meowgo/nav_bars/studymon_bottom_nav_widget.dart';
import '../pokemon_helpers/db_helper.dart';

class SplashPageWidget extends StatefulWidget {
  const SplashPageWidget({Key? key}) : super(key: key);

  @override
  State<SplashPageWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPageWidget> {
  bool canProceed = false;

  evenWachten() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      canProceed = true;
    });
  }

  @override
  void initState() {
    super.initState();
    DatabaseHelper().checkDatabaseEmptyAndFill();
    evenWachten();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = [
      Colors.red,
      Colors.red,
      Colors.white,
      Colors.white,
    ];
    final stops = [0.0, 0.5, 0.5, 1.0];

    return canProceed
        ? const StudyMonNav()
        : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
                stops: stops,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  Stack(children: [
                    Text(
                      'Studémon!',
                      style: TextStyle(
                        fontSize: 50,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 10
                          ..color = Colors.black,
                      ),
                    ),
                    const Text(
                      'Studémon!',
                      style: TextStyle(fontSize: 50, color: Colors.yellow),
                    ),
                  ]),
                ],
              ),
            ),
          );
  }
}

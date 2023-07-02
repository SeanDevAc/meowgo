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
  bool canProceed = false;

  evenWachten() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      canProceed = true;
    });
  }

  @override
  void initState() {
    super.initState();
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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
          stops: stops,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(children: [
            Text(
              'Studémon!',
              style: TextStyle(
                fontSize: 24,
                // color: Color.fromARGB(255, 255, 255, 255),
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 10
                  ..color = Colors.white,
              ),
            ),
            const Text(
              'Studémon!',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ]),
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
    );
  }
}

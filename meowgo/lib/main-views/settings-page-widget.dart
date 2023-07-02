import 'package:flutter/material.dart';
import 'package:meowgo/component/db_helper.dart';

class SettingsStatsWidget extends StatelessWidget {
  const SettingsStatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red, // Change the color here
            Colors.red, // Change the color here
            Colors.white, // Change the color here
            Colors.white, // Change the color here
          ],
          stops: [0.0, 0.5, 0.5, 1.0],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 20.0,
            color: Colors.black,
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 20.0),
            ),
          ),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.red.shade50, // Change the color here
              shape: BoxShape.circle,
            ),
          ),
          Column(
            children: [
              const Text('Page 3'),
              TextButton(
                onPressed: () => DatabaseHelper().nukeDatabaseAndFill(),
                child: Text("Reset Game"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

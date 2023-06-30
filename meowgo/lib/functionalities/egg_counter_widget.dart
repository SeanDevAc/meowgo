import 'package:flutter/material.dart';

class EggCounterWidget extends StatelessWidget {
  int _eggAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text('$_eggAmount'),
    );
  }
}

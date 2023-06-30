import 'package:flutter/material.dart';
import '../component/db_helper.dart';

class EggCounterWidget extends StatelessWidget {
  int _eggAmount = 0;

  void getEggAmount() async {
    _eggAmount = await DatabaseHelper().getEggAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('Eggs: $_eggAmount'),
    );
  }
}

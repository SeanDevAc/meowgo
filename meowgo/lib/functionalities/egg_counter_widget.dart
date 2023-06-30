import 'package:flutter/material.dart';
import '../component/db_helper.dart';
import 'dart:async';

class EggCounterStateful extends StatefulWidget {
  const EggCounterStateful({super.key});

  @override
  State<EggCounterStateful> createState() => _EggCounterWidget();
}

class _EggCounterWidget extends State<EggCounterStateful> {
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

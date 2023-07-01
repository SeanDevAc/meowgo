import 'package:flutter/material.dart';
import 'dart:async';
import '../component/db_helper.dart';

class EggCounterStateful extends StatefulWidget {
  const EggCounterStateful({super.key});

  void getEggAmount() {
    _EggCounterWidget().getEggAmount();
  }

  @override
  State<EggCounterStateful> createState() => _EggCounterWidget();
}

class _EggCounterWidget extends State<EggCounterStateful> {
  int _eggAmount = 0;

  Future<int>? getEggAmount() async {
    Future<int>? amount = DatabaseHelper().getEggAmount();
    setState(() {
      _eggAmount = amount as int;
    });
    return amount;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: getEggAmount(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('${snapshot.data}');
              } else {
                return const Text('0');
              }
            }));
  }
}

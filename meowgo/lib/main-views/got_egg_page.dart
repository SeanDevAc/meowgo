import 'package:flutter/material.dart';
import 'step_count_page.dart';
import '../component/db_helper.dart';

class GotEggPage extends StatelessWidget {
  const GotEggPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text("congrats, you got an egg!"),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('Extra egg?'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return StepCountPage(); //variabele meegeven?
                }));
              },
            ),
          ),
          Center(
            child: TextButton(
              child: const Text('Collect Egg'),
              onPressed: () => DatabaseHelper().addEggs(1),
            ),
          )
        ],
      ),
    );
  }
}

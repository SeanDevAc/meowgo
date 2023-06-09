import 'package:flutter/material.dart';
import 'package:meowgo/pokemon_helpers/db_helper.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool isUnlocked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red,
            Colors.red,
            Colors.white,
            Colors.white,
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
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isUnlocked = !isUnlocked;
                  });
                },
                icon: Icon(isUnlocked ? Icons.lock_open : Icons.lock),
                label: Text(
                    isUnlocked ? "Lock Reset Button" : "Unlock Reset Button"),
              ),
              const SizedBox(height: 20.0),
              Opacity(
                opacity: isUnlocked ? 1.0 : 0.5,
                child: TextButton(
                  onPressed: isUnlocked
                      ? () => _showResetConfirmationDialog(context)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 8.0),
                        Text(
                          "Reset Collection",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reset Collection"),
          content: const Text(
              "Are you sure you want to reset your Pokemon collection?"),
          actions: [
            TextButton(
              onPressed: () {
                DatabaseHelper().nukeDatabaseAndFill();
                Navigator.of(context).pop();
              },
              child: const Text("Reset"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}

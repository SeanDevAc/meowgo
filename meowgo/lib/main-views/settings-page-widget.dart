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
              SizedBox(height: 20.0), 
              TextButton(
                onPressed: () => _showResetConfirmationDialog(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  child: Text(
                    "Reset Collection",
                    style: TextStyle(
                      color: Colors.red, 
                      fontWeight: FontWeight.bold,
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
          title: Text("Reset Collection"),
          content: Text("Are you sure you want to reset your Pokemon collection?"),
          actions: [
            TextButton(
              onPressed: () {
                DatabaseHelper().nukeDatabaseAndFill();
                Navigator.of(context).pop();
              },
              child: Text("Reset"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}

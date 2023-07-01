import 'package:flutter/material.dart';
import 'package:meowgo/component/db_helper.dart';

class SettingsStatsWidget extends StatelessWidget {
  const SettingsStatsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.inversePrimary,
      alignment: Alignment.center,
      child: Column(
        children: [
          const Text('Page 3'),
          TextButton(
              onPressed: () => DatabaseHelper().nukeDatabaseAndFill(),
              child: Text("reset game"))
        ],
      ),
    );
  }
}

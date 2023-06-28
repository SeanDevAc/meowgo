import 'package:flutter/material.dart';

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
      child: const Text('Page 3'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Placeholder(
      child: Center(
        child: Text(
          "Settings",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

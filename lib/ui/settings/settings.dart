import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/ui/intro/intro.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        // remove accounts and start again
        ListTile(
          title: const Text('Clear accounts'),
          trailing: const Icon(Icons.delete, color: Colors.red),
          onTap: () {
            ref.read(accountTreeProvider.notifier).clear();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const IntroScreen()));
          },
        ),
      ],
    );
  }
}

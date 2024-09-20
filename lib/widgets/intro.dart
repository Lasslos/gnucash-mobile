import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/providers/accounts.dart';

class Intro extends ConsumerWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: TextButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result == null) {
            return;
          }
          try {
            final _file = File(result.files.single.path!);
            String contents = await _file.readAsString();
            ref.read(accountsProvider.notifier).setAccounts(contents);
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Oops, something went wrong while importing. Please correct any errors in your Accounts CSV and try again.",
                ),
              ),
            );
          }
        },
        child: const Text(
          "Import",
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/providers/transactions.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportScreen extends ConsumerWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Export your transactions to a file",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              "Here's what to do with it:",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "1. ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Expanded(
                  child: Text(
                    "Upload the file to your computer",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "2. ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "In GnuCash, select ",
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: const [
                        TextSpan(
                          text:
                              "File > Import > Import\u{00A0}Transactions\u{00A0}from\u{00A0}CSV",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "3. ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Expanded(
                  child: Text(
                    "Select the file",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "4. ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "In ",
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: const [
                        TextSpan(
                          text: "Load\u{00A0}and\u{00A0}Save\u{00A0}Settings",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ", select ",
                        ),
                        TextSpan(
                          text: "\"GnuCash\u{00A0}Export\u{00A0}Format\"",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => saveToDownloads(context, ref),
                  label: const Text("Save to Downloads"),
                  icon: const Icon(Icons.download),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () => shareFile(context, ref),
                  label: const Text("Share"),
                  icon: const Icon(Icons.share),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveToDownloads(BuildContext context, WidgetRef ref) async {
    String csv = ref.read(transactionsCSVProvider);
    final Directory? downloadsDir = await getDownloadsDirectory();
    if (downloadsDir == null) {
      if (!context.mounted) {
        return;
      }
      showFailureSnackBar(context);
      return;
    }
    final File file = File("${downloadsDir.path}/${DateFormat("y-m-d").format(DateTime.now())}-transactions.csv");
    try {
      await file.writeAsString(csv);
    } catch (e, s) {
      Logger().e("Failed to write to file", error: e, stackTrace: s);
      if (!context.mounted) {
        return;
      }
      showFailureSnackBar(context);
      return;
    }
    if (!context.mounted) {
      return;
    }
    showSuccessSnackBar(context);
  }
  Future<void> shareFile(BuildContext context, WidgetRef ref) async {
    String csv = ref.read(transactionsCSVProvider);
    ShareResult result = await Share.shareXFiles(
      [
        XFile.fromData(
          utf8.encode(csv),
          mimeType: "text/plain",
          name: "transactions.csv",
        ),
      ],
      subject: "GnuCash transactions",
      fileNameOverrides: ["${DateFormat("y-m-d").format(DateTime.now())}-transactions.csv"],
    );

    bool success = result.status == ShareResultStatus.success;

    if (!context.mounted) {
      return;
    }
    success ? showSuccessSnackBar(context) : showFailureSnackBar(context);
  }

  Future<void> showSuccessSnackBar(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Transactions exported successfully"),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
      ),
    );
  }
  Future<void> showFailureSnackBar(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to export transactions"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        closeIconColor: Colors.white,
      ),
    );
  }
}

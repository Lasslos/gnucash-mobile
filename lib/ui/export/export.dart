import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/core/providers/transactions.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  _ExportState createState() => _ExportState();
}

class _ExportState extends ConsumerState<ExportScreen> {
  String _directoryPath = "/";
  String _directory = "/";

  bool deleteTransactionsOnExport = false;

  @override
  void initState() {
    if (Platform.isIOS) {
      getApplicationDocumentsDirectory().then((value) {
        _directoryPath = value.path;
      });
    }

    super.initState();
  }

  void _selectFolder() {
    FilePicker.platform.getDirectoryPath().then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _directoryPath = value;
        _directory = value.substring(value.lastIndexOf("/"));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String transactionCSV = ref.watch(transactionsCSVProvider);
    // Remove 1 for header row, divide by 2 for double entry
    final _numTransactions = ("\n".allMatches(transactionCSV).length - 1) / 2;
    String _text = "${_numTransactions.toInt()} transaction(s)";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Export Transactions"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Platform.isIOS
                  ? Text(
                      "$_text will be written to this application's directory (/On My iPhone/GnuCashMobile)",
                    )
                  : Text("Export to: $_directory"),
            ),
            Platform.isIOS
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: () => _selectFolder(),
                    child: const Text(
                      "Pick directory",
                    ),
                  ),
            CheckboxListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
              title: const Text('Delete transactions on successful export'),
              value: deleteTransactionsOnExport,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  deleteTransactionsOnExport = value;
                });
              },
            ),
            TextButton(
              onPressed: () async {
                final _yearMonthDay =
                    DateFormat('yyyyMMdd').format(DateTime.now());
                try {
                  final _fileName =
                      "$_directoryPath/${_yearMonthDay}_${DateTime.now().millisecond}.gnucash_transactions.csv";
                  await File(_fileName).writeAsString(transactionCSV);

                  if (deleteTransactionsOnExport) {
                    for (Account account in ref.read(allAccountsProvider)) {
                      ref.read(transactionsProvider(account).notifier).removeAll();
                    }
                  }

                  Navigator.pop(context, true);
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error exporting!")),
                  );
                }
              },
              child: const Text(
                "Export",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

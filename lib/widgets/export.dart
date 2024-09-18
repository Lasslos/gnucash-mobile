import 'dart:io';

// The commented code in this file is for choosing a directory to export to.
// This works on Android, but on iOS we can't write a file to external storage.
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/constants.dart';
import 'package:gnucash_mobile/providers/transactions.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Export extends ConsumerStatefulWidget {
  const Export({super.key});

  @override
  _ExportState createState() => _ExportState();
}

class _ExportState extends ConsumerState<Export> {
  late String _directoryPath;
  late String _directory;

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
    String transactionCSV = ref.watch(transactionsProvider.notifier).getCSV();
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
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        darkAccent,
                      ),
                    ),
                    onPressed: () => _selectFolder(),
                    child: Text(
                      "Pick directory",
                      style: TextStyle(
                        color: lightPrimary,
                      ),
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
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  darkAccent,
                ),
              ),
              onPressed: () async {
                final _yearMonthDay =
                    DateFormat('yyyyMMdd').format(DateTime.now());
                try {
                  final _fileName =
                      "$_directoryPath/${_yearMonthDay}_${DateTime.now().millisecond}.gnucash_transactions.csv";
                  await File(_fileName).writeAsString(transactionCSV);

                  if (deleteTransactionsOnExport) {
                    ref.read(transactionsProvider.notifier).removeAll();
                  }

                  Navigator.pop(context, true);
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error exporting!")),
                  );
                }
              },
              child: Text(
                "Export",
                style: TextStyle(
                  color: lightPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

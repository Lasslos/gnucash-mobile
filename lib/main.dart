import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/core/providers/transactions.dart';
import 'package:gnucash_mobile/utils.dart';
import 'package:gnucash_mobile/ui/export.dart';
import 'package:gnucash_mobile/ui/favorites.dart';
import 'package:gnucash_mobile/ui/intro.dart';
import 'package:gnucash_mobile/ui/list_of_accounts.dart';
import 'package:gnucash_mobile/ui/transaction_form.dart';
import 'package:intl/number_symbols_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSharedPreferences();
  await initTransactions();
  await initAccounts();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GnuCash Mobile",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
      supportedLocales: numberFormatSymbols.keys
          .where((key) => key.toString().contains('_'))
          .map((key) => key.toString().split('_'))
          .map((split) => Locale(split[0], split[1]))
          .toList(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final savedAccounts = <Account>[];

  @override
  Widget build(BuildContext context) {
    List<Account> accounts = ref.watch(accountsProvider);
    bool hasImported = accounts.isNotEmpty;

    List<Transaction> transactions = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      body: hasImported ? ListOfAccounts(accounts: accounts) : const Intro(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              child: Text(
                "GnuCash Mobile",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              title: const Text('Import Accounts'),
              onTap: () async {
                if (hasImported) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Accounts already imported. Please remove them first.",
                      ),
                    ),
                  );
                  Navigator.pop(context);
                  return;
                }

                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result == null) {
                  Navigator.pop(context);
                  return;
                }

                try {
                  final _file = File(result.files.single.path!);
                  String contents = await _file.readAsString();
                  ref.read(accountsProvider.notifier).setAccounts(contents);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Oops, something went wrong while importing. Please correct any errors in your Accounts CSV and try again.",
                      ),
                    ),
                  );
                }
              },
            ),
            ListTile(
              title: const Text('Export'),
              onTap: () async {
                final _success = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Export(),
                  ),
                );

                if (_success != null && _success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Transactions exported!"),
                    ),
                  );
                }
              },
            ),
            ListTile(
              title: const Text('Favorites'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Favorites(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Delete Accounts'),
              onTap: () {
                _showConfirm(
                    context, 'Are you sure you want to delete accounts?',
                    () async {
                  await ref.read(accountsProvider.notifier).clearAccounts();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Accounts deleted.")),
                  );
                }, () {
                  Navigator.of(context).pop();
                });
              },
            ),
            ListTile(
              title: Text(
                'Delete ${transactions.length ~/ 2} Transaction(s)',
              ),
              onTap: () {
                if (transactions.isEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No transactions to delete."),
                    ),
                  );
                }

                _showConfirm(
                    context, 'Are you sure you want to delete transactions?',
                    () {
                  ref.read(transactionsProvider.notifier).removeAll();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Transactions deleted."),
                    ),
                  );
                }, () {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: hasImported
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final _success = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionForm(),
                  ),
                );

                if (_success != null && _success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Transaction created!"),
                    ),
                  );
                }
              },
            )
          : null,
    );
  }

  void _showConfirm(
    BuildContext context,
    String message,
    Function() onConfirm,
    Function() onCancel,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: onConfirm,
            ),
            TextButton(
              child: const Text('No'),
              onPressed: onCancel,
            ),
          ],
        );
      },
    );
  }
}

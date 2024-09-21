
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/account_node.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/core/providers/transactions.dart';
import 'package:gnucash_mobile/ui/export.dart';
import 'package:gnucash_mobile/ui/favorites.dart';
import 'package:gnucash_mobile/ui/intro/intro.dart';
import 'package:gnucash_mobile/ui/list_of_accounts.dart';
import 'package:gnucash_mobile/ui/transaction_form.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final savedAccounts = <Account>[];

  @override
  Widget build(BuildContext context) {
    List<AccountNode> accountNodes = ref.watch(rootAccountNodesProvider);
    bool hasImported = accountNodes.isNotEmpty;

    List<Account> accounts = ref.watch(allAccountsProvider);
    List<Transaction> allTransactions = [];
    for (Account account in accounts) {
      allTransactions += ref.watch(transactionsProvider(account));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      body: hasImported ? ListOfAccounts(accountNodes: accountNodes) : const IntroScreen(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              child: Text(
                "GnuCash Refined",
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
                  ref.read(rootAccountNodesProvider.notifier).setCSV(contents);
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
                      await ref.read(rootAccountNodesProvider.notifier).clear();
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
                'Delete ${allTransactions.length ~/ 2} Transaction(s)',
              ),
              onTap: () {
                if (allTransactions.isEmpty) {
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
                      for (Account account in accounts) {
                        ref.read(transactionsProvider(account).notifier).removeAll();
                      }
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

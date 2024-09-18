import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gnucash_mobile/providers/accounts.dart';
import 'package:gnucash_mobile/providers/transactions.dart';
import 'package:gnucash_mobile/widgets/export.dart';
import 'package:gnucash_mobile/widgets/favorites.dart';
import 'package:gnucash_mobile/widgets/intro.dart';
import 'package:gnucash_mobile/widgets/list_of_accounts.dart';
import 'package:gnucash_mobile/widgets/transaction_form.dart';
import 'package:gnucash_mobile/constants.dart';

void main() {
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
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: Constants.lightTheme,
      darkTheme: Constants.darkTheme,
      home: const MyHomePage(title: 'Accounts'),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final savedAccounts = <Account>[];

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountsModel>(builder: (context, accountsModel, child) {
      return FutureBuilder<List<Account>>(
          future: Provider.of<AccountsModel>(context, listen: false).accounts,
          builder: (context, AsyncSnapshot<List<Account>> snapshot) {
            final accounts = snapshot.hasData ? snapshot.data : [];
            final _hasImported = accounts.length > 0;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Constants.darkBG,
                title: Text(widget.title),
              ),
              body: _hasImported ? ListOfAccounts(accounts: accounts) : const Intro(),
              drawer: Drawer(
                  child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text(
                      "GnuCash Mobile",
                      style: TextStyle(
                        color: Constants.lightPrimary,
                        fontSize: 20,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Constants.darkBG,
                    ),
                  ),
                  ListTile(
                      title: const Text('Import Accounts'),
                      onTap: () async {
                        if (_hasImported) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Accounts already imported. Please remove them first.",),
                          ),);
                          Navigator.pop(context);
                          return;
                        }

                        FilePickerResult result =
                            await FilePicker.platform.pickFiles();

                        try {
                          final _file = File(result.files.single.path);
                          String contents = await _file.readAsString();
                          Provider.of<AccountsModel>(context, listen: false)
                              .addAll(contents);
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Oops, something went wrong while importing. Please correct any errors in your Accounts CSV and try again.",),
                          ),);
                        }
                                            },),
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
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Transactions exported!"),),);
                        }
                      },),
                  ListTile(
                      title: const Text('Favorites'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Favorites(),
                          ),
                        );
                      },),
                  ListTile(
                      title: const Text('Delete Accounts'),
                      onTap: () {
                        _showConfirm(context, 'Are you sure you want to delete accounts?', () {
                          Provider.of<AccountsModel>(context, listen: false)
                              .removeAll();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Accounts deleted.")),);
                        }, () {
                          Navigator.of(context).pop();
                        });
                      },),
                  FutureBuilder(
                    future:
                        Provider.of<TransactionsModel>(context, listen: true)
                            .transactions,
                    builder:
                        (context, AsyncSnapshot<List<Transaction>> snapshot) {
                      return ListTile(
                          title: Text(
                              'Delete ${snapshot.hasData ? snapshot.data.length ~/ 2 : 0} Transaction(s)',),
                          onTap: () {
                            if (!snapshot.hasData ||
                                snapshot.data.length == 0) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("No transactions to delete."),),);
                            }

                            _showConfirm(context, 'Are you sure you want to delete transactions?', () {
                              Provider.of<TransactionsModel>(context,
                                  listen: false,)
                                  .removeAll();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Transactions deleted."),),);
                            }, () {
                              Navigator.of(context).pop();
                            });
                          },);
                    },
                  ),
                ],
              ),),
              floatingActionButton: _hasImported
                  ? Builder(builder: (context) {
                      return FloatingActionButton(
                        backgroundColor: Constants.darkBG,
                        child: const Icon(Icons.add),
                        onPressed: () async {
                          final _success = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TransactionForm(),
                            ),
                          );

                          if (_success != null && _success) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Transaction created!"),),);
                          }
                        },
                      );
                    },)
                  : null,
            );
          },);
    },);
  }

  void _showConfirm(BuildContext context, String message, Function() onConfirm, Function() onCancel) async {
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account_node.dart';
import 'package:gnucash_mobile/ui/export/export.dart';
import 'package:gnucash_mobile/ui/home/accounts.dart';
import 'package:gnucash_mobile/ui/home/transactions.dart';
import 'package:gnucash_mobile/ui/settings/settings.dart';
import 'package:gnucash_mobile/ui/transaction_form.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/":
              if (_selectedIndex != 0) {
                setState(() {
                  _selectedIndex = 0;
                });
              }
              return MaterialPageRoute(
                builder: (context) => const AccountView(),
              );
            case "/transactions":
              if (_selectedIndex != 1) {
                setState(() {
                  _selectedIndex = 1;
                });
              }
              assert(settings.arguments is AccountNode?, "AccountNode required for transactions route");
              return MaterialPageRoute(
                builder: (context) => TransactionsView(accountNode: settings.arguments as AccountNode?),
              );
            case "/export":
              if (_selectedIndex != 2) {
                setState(() {
                  _selectedIndex = 2;
                });
              }
              return MaterialPageRoute(
                builder: (context) => const ExportScreen(),
              );
            case "/settings":
              if (_selectedIndex != 3) {
                setState(() {
                  _selectedIndex = 3;
                });
              }
              return MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              );
            default:
              throw UnimplementedError("Route not implemented: ${settings.name}");
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree),
            label: "Accounts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: "Transactions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: "Export",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
      floatingActionButton: _selectedIndex < 2 ? FloatingActionButton.extended(
        label: const Text("Create Transaction"),
        icon: const Icon(Icons.add),
        heroTag: "create_transaction",
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionForm(),
            ),
          );
        },
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        _navigatorKey.currentState!.pushReplacementNamed("/");
        break;
      case 1:
        _navigatorKey.currentState!.pushReplacementNamed("/transactions", arguments: null);
        break;
      case 2:
        _navigatorKey.currentState!.pushReplacementNamed("/export");
        break;
      case 3:
        _navigatorKey.currentState!.pushReplacementNamed("/settings");
        break;
    }
  }
}

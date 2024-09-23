import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  int _selectedIndexIntern = 0;

  int get _selectedIndex => _selectedIndexIntern;

  set _selectedIndex(int value) {
    setState(() {
      if (value < _selectedIndexIntern) {
        _reverseDirection = true;
      } else {
        _reverseDirection = false;
      }
      _selectedIndexIntern = value;
    });
  }

  // Whether to reverse the direction of the page transition.
  bool _reverseDirection = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          alignment: Alignment.center,
          child: Image.asset(
            width: 32,
            height: 32,
            fit: BoxFit.cover,
            "assets/icons/gnucash_logo.png",
          ),
        ),
        title: const Text("GnuCash Refined"),
        centerTitle: true,
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        reverse: _reverseDirection,
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: const [
          AccountsScreen(),
          TransactionsView(account: null),
          ExportScreen(),
          SettingsScreen(),
        ][_selectedIndex],
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
      floatingActionButton: _selectedIndex < 2
          ? FloatingActionButton.extended(
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
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account_node.dart';
import 'package:gnucash_mobile/ui/list_of_accounts.dart';
import 'package:gnucash_mobile/ui/transaction_form.dart';
import 'package:gnucash_mobile/ui/transactions_view.dart';

class AccountView extends ConsumerWidget {
  final AccountNode accountNode;

  const AccountView({required this.accountNode, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Deliver simpler view if this account cannot hold transactions
    if (this.accountNode.account.placeholder) {
      return Scaffold(
        appBar: AppBar(
          title: Text(this.accountNode.account.fullName),
        ),
        body: ListOfAccounts(accountNodes: accountNode.children),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
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
                    const SnackBar(content: Text("Transaction created!")),
                  );
                }
              },
            );
          },
        ),
      );
    }

    // Deliver a tabbed view with both sub-accounts and transactions
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.account_tree_sharp)),
              Tab(icon: Icon(Icons.account_balance_sharp)),
            ],
          ),
          title: Text(this.accountNode.account.fullName),
        ),
        body: TabBarView(
          children: [
            ListOfAccounts(accountNodes: accountNode.children),
            TransactionsView(
              account: accountNode.account,
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final _success = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionForm(
                      toAccount: accountNode.account,
                    ),
                  ),
                );

                if (_success != null && _success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Transaction created!")),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/account_node.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/core/providers/balance.dart';
import 'package:gnucash_mobile/ui/home/transactions.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TreeNode<AccountNode> accountTree = TreeNode<AccountNode>.root();
    TreeNode<AccountNode> buildAccountTree(AccountNode account) {
      TreeNode<AccountNode> node = TreeNode<AccountNode>(data: account)
        ..addAll(account.children.map(buildAccountTree));
      return node;
    }

    List<AccountNode> accountNodes = ref.watch(accountTreeProvider);
    accountTree.addAll(accountNodes.map(buildAccountTree));

    return SafeArea(
      child: TreeView.simple(
        showRootNode: false,
        builder: (context, node) {
          return AccountTreeNodeWidget(node: node);
        },
        expansionIndicatorBuilder: (context, node) {
          return NoExpansionIndicator(tree: node);
        },
        tree: accountTree,
      ),
    );
  }
}

class AccountTreeNodeWidget extends ConsumerWidget {
  const AccountTreeNodeWidget({required this.node, super.key});

  final TreeNode<AccountNode> node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AccountNode? accountNode = node.data;
    if (accountNode == null) {
      return const SizedBox.shrink();
    }

    bool isExpanded = node.isExpanded;
    bool hasChildren = !node.isLeaf;
    double balance = ref.watch(balanceProvider(accountNode));
    Account account = accountNode.account;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ListTile(
        leading: hasChildren
            ? AnimatedRotation(
                turns: isExpanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: const Icon(Icons.arrow_right),
              )
            : null,
        title: Text(account.name),
        onTap: account.placeholder
            ? null
            : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        TransactionsView(account: accountNode.account),
                  ),
                );
              },
        //TODO: Localize currency
        trailing: Text(
          balance.toStringAsFixed(2),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: balance.isNegative ? Colors.red : null,
          ),
        ),
      ),
    );
  }
}

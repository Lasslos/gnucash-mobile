import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/account_node.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';

class AccountFormField extends FormField<Account?> {
  final void Function(Account?) onChanged;
  final String labelText;

  AccountFormField({
    required this.labelText,
    required this.onChanged,
    required super.initialValue,
    required super.validator,
    super.key,
  }) : super(
    builder: (state) {
      return AccountField(
        onChanged: (account) {
          state.didChange(account);
          onChanged(account);
        },
        labelText: labelText,
        errorText: state.errorText,
      );
    },
  );
}

class AccountField extends ConsumerStatefulWidget {
  final void Function(Account?) onChanged;
  final String labelText;
  final String? errorText;

  const AccountField({required this.onChanged, required this.labelText, this.errorText, super.key});

  @override
  ConsumerState createState() => _AccountFieldState();
}

class _AccountFieldState extends ConsumerState<AccountField> {
  late final AutoScrollController scrollController;
  Account? account;

  @override
  void initState() {
    super.initState();
    scrollController = AutoScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(
        text: account?.name ?? 'Choose Account',
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.labelText,
        errorText: widget.errorText,
      ),
      onTap: () async {
        showModalBottomSheet(
          enableDrag: false,
          context: context,
          isScrollControlled: true,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          builder: (context) {
            TreeNode<Account> accountTree = TreeNode<Account>.root();
            TreeNode<Account> buildAccountTree(AccountNode account) {
              TreeNode<Account> node = TreeNode<Account>(data: account.account)..addAll(account.children.map(buildAccountTree));
              return node;
            }

            List<AccountNode> accountNodes = ref.watch(accountTreeProvider);
            accountTree.addAll(accountNodes.map(buildAccountTree));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                shrinkWrap: true,
                controller: scrollController,
                slivers: [
                  SliverTreeView.simple(
                    scrollController: scrollController,
                    showRootNode: false,
                    tree: accountTree,
                    expansionIndicatorBuilder: (context, node) {
                      return NoExpansionIndicator(tree: node);
                    },
                    expansionBehavior: ExpansionBehavior.collapseOthersAndSnapToTop,
                    builder: (context, node) {
                      Account? account = node.data;
                      if (account == null) {
                        return const SizedBox.shrink();
                      }
                      bool isExpanded = node.isExpanded;
                      bool hasChildren = !node.isLeaf;

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        surfaceTintColor: account.placeholder ? Theme.of(context).disabledColor : null,
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
                          trailing: account.placeholder ? null : const Icon(Icons.arrow_forward),
                          onTap: account.placeholder
                              ? null
                              : () {
                            setState(() {
                              this.account = account;
                            });
                            widget.onChanged(account);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

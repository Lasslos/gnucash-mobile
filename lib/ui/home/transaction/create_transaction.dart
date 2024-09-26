import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/account_node.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:uuid/uuid.dart';

Future<DoubleEntryTransaction?> showCreateTransactionDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return const Dialog.fullscreen(
        child: _CreateTransactionView(),
      );
    },
  );
}

class _CreateTransactionView extends ConsumerStatefulWidget {
  const _CreateTransactionView({super.key});

  @override
  ConsumerState createState() => __CreateTransactionViewState();
}

class __CreateTransactionViewState extends ConsumerState<_CreateTransactionView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Account? _debitAccount;
  DateTime _transactionDate = DateTime.now();
  String _description = '';
  String notes = '';
  Account? _transferAccount;
  double? _amount;

  @override
  void initState() {
    super.initState();
    _debitAccount = ref.read(favoriteDebitAccountProvider);
    _transferAccount = ref.read(favoriteCreditAccountProvider);
  }

  @override
  Widget build(BuildContext context) {
    List<Account> transactionAccounts = ref.watch(transactionAccountListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Account first = _debitAccount!;
                  Account second = _transferAccount!;
                  String id = const Uuid().v4();
                  Transaction firstTransaction = Transaction(
                    date: _transactionDate,
                    id: id,
                    description: _description,
                    notes: notes,
                    commodityCurrency: first.namespace + '::' + first.symbol,
                    amount: _amount!,
                  );
                  Transaction secondTransaction = firstTransaction.copyWith(
                    commodityCurrency: second.namespace + '::' + second.symbol,
                    amount: -_amount!,
                  );
                  DoubleEntryTransaction transaction = DoubleEntryTransaction(
                    AccountTransactionPair(first, firstTransaction),
                    AccountTransactionPair(second, secondTransaction),
                  );
                  Navigator.of(context).pop(transaction);
                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.arrow_forward,
                  ),
                  Expanded(
                    child: AccountFormField(
                      initialValue: _debitAccount,
                      onSaved: (value) => _debitAccount = value,
                      validator: (value) => value == null ? 'Please choose an account' : null,
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
                onSaved: (value) => _description = value ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountFormField extends ConsumerStatefulWidget {
  final Account? initialValue;
  final void Function(Account?) onSaved;
  final String? Function(Account?) validator;

  const AccountFormField({required this.initialValue, required this.onSaved, required this.validator, super.key});

  @override
  ConsumerState createState() => _AccountFormFieldState();
}

class _AccountFormFieldState extends ConsumerState<AccountFormField> {
  late final GlobalKey<FormFieldState<Account?>> formFieldKey;
  late final AutoScrollController scrollController;

  @override
  void initState() {
    super.initState();
    formFieldKey = GlobalKey<FormFieldState<Account?>>();
    scrollController = AutoScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<Account?>(
      key: formFieldKey,
      initialValue: widget.initialValue,
      builder: (state) {
        return TextField(
          readOnly: true,
          controller: TextEditingController(
            text: formFieldKey.currentState?.value?.name ?? 'Choose an account',
          ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Account',
          ),
          onTap: () async {
            showBottomSheet(
              enableDrag: false,
              context: context,
              sheetAnimationStyle: AnimationStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                reverseDuration: const Duration(milliseconds: 300),
                reverseCurve: Curves.easeInOut,
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
                                      formFieldKey.currentState?.didChange(account);
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
      },
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}

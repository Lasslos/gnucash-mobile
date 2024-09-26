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
  late final TextEditingController _debitAmountController;
  late final TextEditingController _creditAmountController;

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
    _debitAmountController = TextEditingController();
    _creditAmountController = TextEditingController();
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
              const Divider(),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0, right: 16.0),
                    child: Icon(
                      Icons.arrow_forward,
                    ),
                  ),
                  Expanded(
                    child: AccountFormField(
                      labelText: 'Account',
                      initialValue: _debitAccount,
                      onChanged: (value) {
                        setState(() {
                          _debitAccount = value;
                        });
                      },
                      validator: (value) => value == null ? 'Please choose an account' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0, right: 16.0),
                    child: Icon(
                      Icons.today,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Date',
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: _transactionDate.toIso8601String().split('T').first,
                      ),
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: _transactionDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            _transactionDate = date;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    flex: 3,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                      onSaved: (value) => _description = value ?? '',
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 52.0, top: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Notes (optional)',
                  ),
                  onSaved: (value) => notes = value ?? '',
                ),
              ),
              const Divider(
                height: 32,
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0, right: 16.0),
                    child: Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  Expanded(
                    child: AccountFormField(
                      labelText: 'Transfer Account',
                      initialValue: _transferAccount,
                      onChanged: (value) => _transferAccount = value,
                      validator: (value) => value == null ? 'Please choose an account' : null,
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 32,
              ),
              Row(
                // three text fields, first two editable, last one read only, all number fields
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0, right: 16.0),
                    child: Icon(
                      Icons.attach_money,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      enabled: _debitAccount != null,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: _debitAccount?.type.debitName ?? 'Debit',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _amount = double.tryParse(value);
                        });
                      },
                      controller: _debitAmountController,
                      validator: (value) {
                        if (value == null) {
                          return null;
                        }
                        double? amount = double.tryParse(value);
                        if (amount == null) {
                          return 'Amount invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: TextFormField(
                      enabled: _debitAccount != null,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: _debitAccount?.type.creditName ?? 'Credit',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _debitAmountController.text = '';
                      },
                      controller: _creditAmountController,
                      validator: (value) {
                        if (value == null) {
                          return null;
                        }
                        double? amount = double.tryParse(value);
                        if (amount == null) {
                          return 'Amount invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: TextFormField(
                      enabled: _debitAccount != null,
                      readOnly: true,
                      controller: TextEditingController(
                        text: () {
                          // if account is null or no amount is given or conflicting amounts are given, return empty string
                          if (_debitAccount == null || _amount == null) {
                            return '';
                          }
                          double sign = _debitAccount!.type.debitIsNegative ? -1 : 1;
                          return (_amount! * sign).toStringAsFixed(2);
                        }(),
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      onTap: () {},
                      validator: (value) {
                        if (_amount == null) {
                          return 'Please enter an amount';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Balance',
                      ),
                    ),
                  ),
                ],
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
  final void Function(Account?) onChanged;
  final String? Function(Account?) validator;
  final String labelText;

  const AccountFormField({required this.labelText, required this.initialValue, required this.onChanged, required this.validator, super.key});

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

  Account? get currentValue => formFieldKey.currentState?.value;

  @override
  Widget build(BuildContext context) {
    return FormField<Account?>(
      key: formFieldKey,
      initialValue: widget.initialValue,
      builder: (state) {
        return TextField(
          readOnly: true,
          controller: TextEditingController(
            text: formFieldKey.currentState?.value?.name ?? 'Choose Account',
          ),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: widget.labelText,
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
      },
      validator: widget.validator,
    );
  }
}

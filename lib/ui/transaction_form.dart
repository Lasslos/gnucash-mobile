import 'package:dart_extensions_methods/dart_extension_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/core/providers/transactions.dart';
import 'package:intl/intl.dart';

class TransactionForm extends ConsumerStatefulWidget {
  final Account? toAccount;

  const TransactionForm({super.key, this.toAccount});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends ConsumerState<TransactionForm> {
  @override
  void initState() {
    super.initState();
    _dateInputController.text = DateFormat.yMd().format(DateTime.now());
  }

  final _key = GlobalKey<FormState>();
  final _visibleAmountInputController = TextEditingController();
  final _dateInputController = TextEditingController();

  // Credit account, debit account
  final _transactions = [Transaction.empty(), Transaction.empty()];
  Account? debitAccount;
  Account? creditAccount;

  @override
  void dispose() {
    _visibleAmountInputController.dispose();
    _dateInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _node = FocusScope.of(context);
    final _simpleCurrencyNumberFormat = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(),
    );
    List<Account> validTransactionAccounts =
        ref.watch(validTransactionAccountsProvider);
    Account? favoriteDebitAccount = ref.watch(favoriteDebitAccountProvider);
    Account? favoriteCreditAccount = ref.watch(favoriteCreditAccountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("New transaction"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => Navigator.pop(context),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            );
          },
        ),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            Focus(
              child: TextFormField(
                autofocus: true,
                controller: _visibleAmountInputController,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onEditingComplete: () => _node.nextFocus(),
                onSaved: (value) {
                  if (value == null) {
                    return;
                  }
                  final _amount = _simpleCurrencyNumberFormat.parse(value);
                  _transactions[0] = _transactions[0].copyWith(
                    amount: _amount.toDouble(),
                  );
                  _transactions[1] = _transactions[1].copyWith(
                    amount: -_amount.toDouble(),
                  );
                },
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid amount';
                  }

                  return null;
                },
              ),
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  final _rawValue = _visibleAmountInputController.value.text;
                  final _simpleCurrencyValue = _simpleCurrencyNumberFormat
                      .format(_simpleCurrencyNumberFormat.parse(_rawValue));
                  _visibleAmountInputController.value =
                      _visibleAmountInputController.value.copyWith(
                    text: _simpleCurrencyValue,
                  );
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
              onEditingComplete: () => _node.nextFocus(),
              onSaved: (value) {
                if (value == null) {
                  return;
                }
                _transactions[0] =
                    _transactions[0].copyWith(description: value);
                _transactions[1] =
                    _transactions[1].copyWith(description: value);
              },
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid description';
                }
                return null;
              },
            ),
            DropdownButtonFormField<Account>(
              decoration: const InputDecoration(
                hintText: 'Credit Account',
              ),
              isExpanded: true,
              // TODO: Put recently used first
              items: validTransactionAccounts.map((account) {
                return DropdownMenuItem(
                  value: account,
                  child: Text(
                    account.fullName,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {},
              onSaved: (value) {
                if (value == null) {
                  return;
                }
                creditAccount = value;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please enter a valid account to credit.';
                }
                return null;
              },
              value: validTransactionAccounts.firstWhereOrNull(
                (account) =>
                    account.fullName == favoriteCreditAccount?.fullName,
              ),
            ),
            DropdownButtonFormField<Account>(
              decoration: const InputDecoration(
                hintText: 'Debit Account',
              ),
              isExpanded: true,
              // TODO: put recently used first
              items: validTransactionAccounts.map((account) {
                return DropdownMenuItem(
                  value: account,
                  child: Text(account.fullName),
                );
              }).toList(),
              onChanged: (value) {},
              onSaved: (value) {
                if (value == null) {
                  return;
                }
                debitAccount = value;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please enter a valid account to debit';
                }
                return null;
              },
              value: validTransactionAccounts.firstWhereOrNull(
                (account) => account.fullName == favoriteDebitAccount?.fullName,
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Date',
              ),
              controller: _dateInputController,
              onSaved: (value) {
                if (value == null) {
                  return;
                }
                _transactions[0] = _transactions[0].copyWith(
                  date: DateTime.parse(value),
                );
              },
              onTap: () async {
                final _now = DateTime.now();
                final _date = await showDatePicker(
                  context: context,
                  initialDate: _now,
                  firstDate: DateTime(_now.year - 10),
                  lastDate: DateTime(_now.year + 10),
                );
                if (_date == null) {
                  return;
                }
                _dateInputController.text = DateFormat.yMd().format(_date);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid date';
                }
                try {
                  DateFormat.yMd().parse(value);
                } on FormatException {
                  return 'Please enter a valid date';
                }

                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Notes',
              ),
              textCapitalization: TextCapitalization.sentences,
              onSaved: (value) {
                if (value == null) {
                  return;
                }
                _transactions[0] = _transactions[0].copyWith(notes: value);
              },
            ),
          ],
        ),
        key: _key,
      ),
      floatingActionButton:
          // Builder(builder: (context) {
          FloatingActionButton(
        child: const Icon(Icons.save_sharp),
        onPressed: () {
          // Validate will return true if the form is valid, or false if
          // the form is invalid.
          if (_key.currentState!.validate()) {
            // Process data.
            _key.currentState!.save();
            final id = UniqueKey().toString();
            _transactions[0] = _transactions[0].copyWith(id: id);
            _transactions[1] = _transactions[1].copyWith(id: id);
            assert(creditAccount != null, "credit account must not be null");
            assert(debitAccount != null, "debit account must not be null");
            ref.read(transactionsProvider(creditAccount!).notifier).add(
                  _transactions[0],
                );
            ref.read(transactionsProvider(debitAccount!).notifier).add(
                  _transactions[1],
                );
            Navigator.pop(context, true);
          } else {
            print("invalid form");
          }
        },
      ),
    );
  }
}

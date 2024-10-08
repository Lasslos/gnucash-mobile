import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/core/providers/favorites.dart';
import 'package:gnucash_mobile/ui/home/transaction/account_field.dart';
import 'package:logger/logger.dart';

Future<Transaction?> showCreateTransactionDialog({
  required BuildContext context,
  Account? initialAccount,
}) async {
  return showDialog<Transaction>(
    context: context,
    builder: (context) {
      return Dialog.fullscreen(
        child: CreateTransactionDialog(
          initialAccount: initialAccount,
        ),
      );
    },
  );
}

class CreateTransactionDialog extends StatefulWidget {
  const CreateTransactionDialog({super.key, this.initialAccount});

  final Account? initialAccount;

  @override
  State createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<CreateTransactionDialog> {
  int _stepIntern = 0;

  int get _step => _stepIntern;

  set _step(int value) {
    setState(() {
      _reverseDirection = value < _stepIntern;
      _stepIntern = value;
    });
  }

  // Whether to reverse the direction of the page transition.
  bool _reverseDirection = false;

  Account? firstAccount;
  Account? secondAccount;

  // The amount that is booked in the first account.
  // The second account will have the negative amount.
  double? amount;

  DateTime date = DateTime.now();
  String? description;
  String? notes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(null),
        ),
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
        child: [
          _FirstAccountView(
            onComplete: (account) {
              setState(() {
                firstAccount = account;
              });
              _step = 1;
            },
          ),
        ][_step],
      ),
    );
  }
}

class _FirstAccountView extends ConsumerStatefulWidget {
  const _FirstAccountView({
    required this.onComplete,
    super.key,
  });

  final void Function(Account) onComplete;

  @override
  ConsumerState<_FirstAccountView> createState() => _FirstAccountViewState();
}

class _FirstAccountViewState extends ConsumerState<_FirstAccountView> {
  Account? _selectedAccount;

  @override
  Widget build(BuildContext context) {
    List<Account> accounts = ref.watch(firstAccountFavoritesProvider);

    return Scaffold(
      body: ListView.builder(
        itemCount: accounts.length + 2,
        itemBuilder: (context, item) {
          if (item == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 32.0,
              ),
              child: Text(
                "Which account do you want to create a transaction for?",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            );
          }
          if (item == accounts.length + 1) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: const Text('Pick another account'),
                  onTap: () async {
                    Account? account = await showAccountPickerDialog(
                      context: context,
                      accountNodes: ref.read(accountTreeProvider),
                    );
                    if (account != null) {
                      _onAccountSelected(account);
                    }
                  },
                  trailing: const Icon(Icons.arrow_forward),
                ),
              ),
            );
          }

          Account account = accounts[item - 1];
          return Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
            child: Card(
              color: () {
                ThemeData theme = Theme.of(context);
                if (account == _selectedAccount) {
                  return theme.colorScheme.primaryContainer;
                } else if (!account.placeholder) {
                  return null;
                } else {
                  return theme.colorScheme.surfaceContainerLow;
                }
              }(),
              child: ListTile(
                title: Text(account.name),
                onTap: account.placeholder ? null : () => _onAccountSelected(account),
                trailing: account == _selectedAccount ? const Icon(Icons.check) : const Icon(Icons.arrow_forward),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            const Spacer(),
            FilledButton(
              onPressed: () {
                if (_selectedAccount != null) {
                  widget.onComplete(_selectedAccount!);
                }
              },
              child: const Text('Next'),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
    );
  }

  void _onAccountSelected(Account account) {
    ref.read(firstAccountFavoritesProvider.notifier).push(account);
    setState(() {
      _selectedAccount = account;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/providers/accounts.dart';


class Favorites extends ConsumerWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Account> validTransactionAccounts =
        ref.watch(validTransactionAccountsProvider);
    Account? favoriteDebitAccount = ref.watch(favoriteDebitAccountProvider);
    Account? favoriteCreditAccount = ref.watch(favoriteCreditAccountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButton<Account>(
                hint: const Text("Favorite Debit Account"),
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
                onChanged: (value) {
                  if (value != null) {
                    ref.read(favoriteDebitAccountProvider.notifier).set(value);
                  }
                },
                value: validTransactionAccounts.firstWhere(
                  (account) =>
                      account.fullName == favoriteDebitAccount?.fullName,
                ),
              ),
              DropdownButton<Account>(
                hint: const Text("Favorite Credit Account"),
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
                onChanged: (value) {
                  if (value != null) {
                    ref.read(favoriteCreditAccountProvider.notifier).set(value);
                  }
                },
                value: validTransactionAccounts.firstWhere(
                  (account) =>
                      account.fullName == favoriteCreditAccount?.fullName,
                ),
              ),
              const Divider(
                height: 50,
                color: Colors.transparent,
              ),
              TextButton(
                onPressed: () {
                  ref.read(favoriteDebitAccountProvider.notifier).clear();
                },
                child: const Text(
                  "Clear favorite debit account",
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(favoriteCreditAccountProvider.notifier).clear();
                },
                child: const Text(
                  "Clear favorite credit account",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

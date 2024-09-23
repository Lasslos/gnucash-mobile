
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/ui/home/home.dart';
import 'package:gnucash_mobile/ui/intro/intro.dart';
import 'package:gnucash_mobile/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSharedPreferences();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool hasImportedAccounts = ref.read(accountTreeProvider).isNotEmpty;

    return MaterialApp(
      title: "GnuCash Refined",
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: hasImportedAccounts ? const HomeScreen() : const IntroScreen(),
    );
  }
}

import 'dart:io';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animations/animations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/account_node.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/ui/home/home_screen.dart';
import 'package:gnucash_mobile/ui/intro/intro_state.dart';

class IntroScreen extends ConsumerWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => PageTransitionSwitcher(
        transitionBuilder: (child, animation, secondaryAnimation) =>
            SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        ),
        child: switch (ref.watch(introStateProvider)) {
          0 => const WelcomePage(),
          1 => const ImportPage(),
          2 => const ApprovePage(),
          _ => const Placeholder(),
        },
      );
}

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 4,
              ),
              margin: const EdgeInsets.symmetric(vertical: 32),
              child: Image.asset(
                'assets/icons/gnucash_logo.png',
              ),
            ),
            Text(
              'Welcome to GnuCash Refined!',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Create GnuCash transactions on the go.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              const Spacer(),
              FilledButton(
                onPressed: () {
                  ref.read(introStateProvider.notifier).state = 1;
                },
                child: const Text('Get started'),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      );
}

class ImportPage extends ConsumerWidget {
  const ImportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 32),
                  child: Icon(
                    Icons.upload_file,
                    size: MediaQuery.of(context).size.height / 4,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  'Import your GnuCash account tree',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "1. ",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Expanded(
                            child: Text(
                              "Open GnuCash on your computer",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "2. ",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: const [
                                  TextSpan(
                                    text: 'Choose ',
                                  ),
                                  TextSpan(
                                    text:
                                        'File > Export > Export\u{00A0}Account\u{00A0}Tree\u{00A0}to\u{00A0}CSV',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "3. ",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Expanded(
                            child: Text(
                              "Save the file to your phone",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              const Spacer(),
              FilledButton(
                onPressed: () {
                  importCSVFile(context, ref);
                },
                child: const Text('Import CSV'),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      );

  Future<void> importCSVFile(BuildContext context, WidgetRef ref) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('No file selected'),
          ),
        );
      }
      return;
    }

    try {
      File file = File(result.files.single.path!);
      ref.read(rootAccountNodesProvider.notifier).setCSV(
            await file.readAsString(),
          );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Error importing file: $e'),
          ),
        );
      }
      return;
    }

    List<AccountNode> accountNodes = ref.watch(rootAccountNodesProvider);
    if (accountNodes.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content:
                Text('No accounts were imported. Is this the correct file?'),
          ),
        );
      }
      return;
    }

    ref.read(introStateProvider.notifier).state = 2;
  }
}

class ApprovePage extends ConsumerWidget {
  const ApprovePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TreeNode<Account> accountTree = TreeNode<Account>.root();
    TreeNode<Account> buildAccountTree(AccountNode account) {
      TreeNode<Account> node = TreeNode<Account>(data: account.account)
        ..addAll(account.children.map(buildAccountTree));
      return node;
    }

    List<AccountNode> accountNodes = ref.watch(rootAccountNodesProvider);
    accountTree.addAll(accountNodes.map(buildAccountTree));

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(
                    height: 16,
                  ),
                  Icon(
                    Icons.check_circle_outline,
                    size: MediaQuery.of(context).size.height / 4,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Text(
                    'All set!',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'You can now start creating transactions.\nBelow are the accounts you\'ve imported.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            SliverTreeView.simple(
              builder: (BuildContext context, TreeNode<Account> item) {
                if (item.data == null) {
                  return const SizedBox.shrink();
                }
                return ListTile(
                  title: Text(item.data?.name ?? "Empty title"),
                  subtitle: Text(item.data?.description ?? ""),
                );
              },
              showRootNode: false,
              tree: accountTree,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            const Spacer(),
            FilledButton.tonal(
              onPressed: () {
                ref.read(rootAccountNodesProvider.notifier).clear();
                ref.read(introStateProvider.notifier).state = 1;
              },
              child: const Text('Retry'),
            ),
            const SizedBox(
              width: 16,
            ),
            FilledButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text('Ok'),
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}

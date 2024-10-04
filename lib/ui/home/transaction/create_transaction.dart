import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/ui/home/transaction/transaction_parts_field.dart';

Future<Transaction?> showCreateTransactionDialog(BuildContext context) {
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
  // ignore: unused_element
  const _CreateTransactionView({super.key});

  @override
  ConsumerState createState() => __CreateTransactionViewState();
}

class __CreateTransactionViewState extends ConsumerState<_CreateTransactionView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<TransactionPart> parts = [];
  
  DateTime _date = DateTime.now();
  String _description = '';
  String _notes = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  Transaction transaction = Transaction(
                    commodityCurrency: parts.first.account.namespace + '::' + parts.first.account.symbol,
                    date: _date,
                    description: _description,
                    notes: _notes,
                    parts: parts,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 12.0, right: 16.0),
                    height: 56,
                    alignment: Alignment.centerLeft,
                    child: const Icon(
                      Icons.today,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Date',
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: _date.toIso8601String().split('T').first,
                      ),
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            _date = date;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                      onSaved: (value) => _description = value ?? '',
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
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
                  onSaved: (value) => _notes = value ?? '',
                ),
              ),
              const Divider(
                height: 32,
              ),
              TransactionPartsFormField(
                onSaved: (List<TransactionPart?>? parts) {
                  if (parts == null) {
                    return;
                  }
                  this.parts = parts.nonNulls.toList();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

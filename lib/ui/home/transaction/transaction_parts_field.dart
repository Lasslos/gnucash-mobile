import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/ui/home/transaction/account_field.dart';

class TransactionPartsFormField extends FormField<List<TransactionPart?>?> {
  TransactionPartsFormField({
    required super.onSaved,
    super.key,
  }) : super(
          initialValue: [null, null],
          validator: (List<TransactionPart?>? parts) {
            if (parts == null || parts.isEmpty) {
              return 'Required';
            }
            List<TransactionPart> partsNotNull = parts.nonNulls.toList();
            // Check if sum of parts is zero
            double sum = partsNotNull.fold(0, (sum, part) => sum + part.amount);
            if (sum != 0) {
              return 'Sum of parts must be zero';
            }
            return null;
          },
          builder: (state) {
            return _TransactionPartsFormFieldWidget(
              onChanged: state.didChange,
              errorText: state.errorText,
            );
          },
        );
}

class _TransactionPartsFormFieldWidget extends StatefulWidget {
  const _TransactionPartsFormFieldWidget({required this.onChanged, super.key, this.errorText});

  final String? errorText;
  final void Function(List<TransactionPart?>?) onChanged;

  @override
  State<_TransactionPartsFormFieldWidget> createState() => _TransactionPartsFormFieldWidgetState();
}

class _TransactionPartsFormFieldWidgetState extends State<_TransactionPartsFormFieldWidget> {
  late final List<TransactionPart?> parts;
  late final List<GlobalKey<FormFieldState<TransactionPart>>> _partKeys;

  @override
  void initState() {
    super.initState();
    parts = [null, null];
    _partKeys = [GlobalKey(), GlobalKey()];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < parts.length; i++) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: i >= 2
                      ? IconButton(
                          icon: const Icon(Icons.remove),
                          padding: const EdgeInsets.only(left: 12.0, right: 16.0),
                          color: Theme.of(context).colorScheme.onSurface,
                          onPressed: () {
                            setState(() {
                              parts.removeAt(i);
                              _partKeys.removeAt(i);
                            });
                            widget.onChanged(parts);
                          },
                        )
                      : const SizedBox(width: 52),
                ),
                Expanded(
                  child: TransactionPartFormField(
                    key: _partKeys[i],
                    validator: (part) {
                      if (part == null) {
                        return 'Required';
                      }
                      return null;
                    },
                    onChanged: (part) {
                      parts[i] = part;
                      widget.onChanged(parts);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 8,
          ),
        ],
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: widget.errorText == null
              ? const SizedBox()
              : Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 16.0, bottom: 8.0),
            child: Text(
              widget.errorText!,
              style: Theme.of(context).textTheme.bodySmall?.apply(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add another part'),
            onPressed: () {
              setState(() {
                parts.add(null);
                _partKeys.add(GlobalKey());
              });
              widget.onChanged(parts);
            },
          ),
        ),
      ],
    );
  }
}

class TransactionPartFormField extends FormField<TransactionPart> {
  TransactionPartFormField({
    required super.validator,
    required this.onChanged,
    super.initialValue,
    super.key,
  }) : super(
          builder: (state) {
            return TransactionPartField(
              onChanged: (part) {
                state.didChange(part);
                onChanged(part);
              },
              errorText: state.errorText,
            );
          },
        );

  final void Function(TransactionPart?) onChanged;
}

class TransactionPartField extends ConsumerStatefulWidget {
  const TransactionPartField({required this.onChanged, this.errorText, super.key});

  final void Function(TransactionPart?) onChanged;
  final String? errorText;

  @override
  ConsumerState createState() => _TransactionPartFieldState();
}

class _TransactionPartFieldState extends ConsumerState<TransactionPartField> {
  TransactionPart? part;
  Account? _account;
  double? _amount;

  set amount(double? value) {
    setState(() {
      _amount = value;
    });
    _onChanged();
  }

  late final TextEditingController _debitAmountController;
  late final TextEditingController _creditAmountController;

  @override
  void initState() {
    super.initState();
    _debitAmountController = TextEditingController();
    _creditAmountController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _debitAmountController.dispose();
    _creditAmountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double? amountSigned;
    if (_amount != null && _account != null) {
      amountSigned = _amount! * (_account!.type.debitIsNegative ? -1 : 1);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              flex: 2,
              child: AccountField(
                onChanged: (account) {
                  setState(() {
                    _account = account;
                  });
                  _onChanged();
                },
                labelText: "",
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(
              child: TextField(
                enabled: _account != null && _amount != null,
                readOnly: true,
                ignorePointers: true,
                controller: TextEditingController(
                  text: () {
                    if (amountSigned == null) {
                      return '';
                    }
                    return amountSigned.toStringAsFixed(2);
                  }(),
                ),
                style: TextStyle(
                  color: () {
                    if (amountSigned != null && amountSigned < 0) {
                      return Colors.red;
                    }
                    return null;
                  }(),
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Result',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: TextField(
                enabled: _account != null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: _account?.type.debitName ?? 'Debit',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _creditAmountController.text = '';
                  setState(() {
                    _amount = double.tryParse(value);
                  });
                  _onChanged();
                },
                controller: _debitAmountController,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(
              child: TextField(
                enabled: _account != null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: _account?.type.creditName ?? 'Credit',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _debitAmountController.text = '';
                  setState(() {
                    double? amount = double.tryParse(value);
                    if (amount != null) {
                      _amount = -amount;
                    } else {
                      _amount = null;
                    }
                  });
                  _onChanged();
                },
                controller: _creditAmountController,
              ),
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: widget.errorText == null
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.errorText!,
                    style: Theme.of(context).textTheme.bodySmall?.apply(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ),
        ),
      ],
    );
  }

  void _onChanged() {
    TransactionPart? part;

    if (_account != null && _amount != null) {
      part = TransactionPart(
        account: _account!,
        amount: _amount!,
      );
    } else {
      part = null;
    }
    if (part != this.part) {
      widget.onChanged(part);
      setState(() {
        this.part = part;
      });
    }
  }
}

import 'package:animated_tree_view/helpers/collection_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/ui/home/transaction/account_field.dart';

class TransactionPartsFormField extends FormField<List<TransactionPart?>> {
  TransactionPartsFormField({
    required super.validator,
    required super.onSaved,
    super.key,
    this.allowNonTrailingNull = false,
  }) : super(
    initialValue: [null, null],
    builder: (state) {
      return TransactionPartsField(
        allowNonTrailingNull: allowNonTrailingNull,
        onChanged: (parts) {
          state.didChange(parts);
        },
        errorText: state.errorText,
      );
    },
  );

  final bool allowNonTrailingNull;
}


class TransactionPartsField extends ConsumerStatefulWidget {
  const TransactionPartsField({required this.onChanged, this.errorText, this.allowNonTrailingNull = false, super.key});

  final void Function(List<TransactionPart?>) onChanged;
  final String? errorText;
  final bool allowNonTrailingNull;

  @override
  ConsumerState<TransactionPartsField> createState() => _TransactionPartsFieldState();
}

class _TransactionPartsFieldState extends ConsumerState<TransactionPartsField> {
  late final List<GlobalKey<_TransactionPartFieldState>> _partKeys;
  late final List<TransactionPart?> _parts;

  @override
  void initState() {
    super.initState();
    _partKeys = [
      GlobalKey<_TransactionPartFieldState>(),
      GlobalKey<_TransactionPartFieldState>(),
    ];
    _parts = [null, null];
  }

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        if (widget.errorText != null) Text(
          widget.errorText!,
          style: const TextStyle(
            color: Colors.red,
          ),
        ),
        for (int i = 0; i < _partKeys.length; i++)
          TransactionPartField(
            key: _partKeys[i],
            onChanged: (part) {
              _parts[i] = part;
              if (_parts.length == 2 && _parts.filterNotNull().length == 1) {
                // Autofill the other amount to be the negative of the first amount
                int otherIndex = 1 - i;
                if (_parts[otherIndex] == null) {
                  assert(part != null, "If the other part is null, this part must not be null");
                  _partKeys[otherIndex].currentState!.amount = -part!.amount;
                }
              }
              widget.onChanged(_parts);
            },
            errorText: () {
              if (_parts[i] != null && widget.allowNonTrailingNull) {
                return "";
              }
              bool partIsTrailing = true;
              for (int j = i + 1; j < _parts.length; j++) {
                if (_parts[j] != null) {
                  partIsTrailing = false;
                  break;
                }
              }
              if (partIsTrailing) {
                return "This part cannot be null";
              }
              return "";
            }(),
          ),
        TextButton(
          onPressed: () {
            setState(() {
              _partKeys.add(GlobalKey<_TransactionPartFieldState>());
              _parts.add(null);
            });
          },
          child: const Text('Add another part'),
        ),
      ],
    );
  }
}

class TransactionPartField extends ConsumerStatefulWidget {
  const TransactionPartField({required this.onChanged, this.errorText = "", super.key});

  final void Function(TransactionPart?) onChanged;
  final String errorText;

  @override
  ConsumerState createState() => _TransactionPartFieldState();
}

class _TransactionPartFieldState extends ConsumerState<TransactionPartField> {
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

    return ListBody(
      children: [
        AccountField(
          onChanged: (account) {
            setState(() {
              _account = account;
            });
            _onChanged();
          },
          labelText: "",
          errorText: widget.errorText,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12.0, right: 16.0),
              child: Icon(
                Icons.attach_money,
              ),
            ),
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
            const SizedBox(
              width: 8,
            ),
            Flexible(
              child: TextField(
                enabled: _account != null,
                readOnly: true,
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
      ],
    );
  }

  void _onChanged() {
    if (_account != null && _amount != null) {
      widget.onChanged(TransactionPart(account: _account!, amount: _amount!));
    } else {
      widget.onChanged(null);
    }
  }
}

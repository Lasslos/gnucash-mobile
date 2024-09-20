import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class Account with _$Account {
  const factory Account({
    required String type,
    required String fullName,
    required String name,
    required String code,
    required String description,
    required String color,
    required String notes,
    required String commodityM,
    required String commodityN,
    required bool hidden,
    required bool tax,
    required bool placeholder,
    @Default(0) double balance,
    @Default([]) List<Account> children,
    String? parentFullName,
  }) = _Account;

  const Account._();

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  factory Account.fromCSVLine(List<String> line) {
    line = line.map((e) => e.trim()).toList();

    // Check if account has parent.
    // The full name of the account is in the form
    // "Parent:Child:Grandchild:..."
    String fullName = line[1];
    int lastIndex = fullName.lastIndexOf(":");
    String? parentFullName;
    if (lastIndex > 0) {
      parentFullName = fullName.substring(0, lastIndex);
    }

    return Account(
      type: line[0],
      fullName: line[1],
      name: line[2],
      code: line[3],
      description: line[4],
      color: line[5],
      notes: line[6],
      commodityM: line[7],
      commodityN: line[8],
      hidden: line[9] == 'T',
      tax: line[10] == 'T',
      placeholder: line[11] == 'T',
      parentFullName: parentFullName,
      children: [],
    );
  }
}

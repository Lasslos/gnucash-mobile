import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gnucash_mobile/core/models/account.dart';

part 'account_node.freezed.dart';

/// Account with children.
@Freezed(makeCollectionsUnmodifiable: false)
class AccountNode with _$AccountNode {
  const factory AccountNode({
    required Account account,
    required List<AccountNode> children,
  }) = _AccountNode;

  const AccountNode._();
}
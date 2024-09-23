import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gnucash_mobile/core/models/account.dart';

part 'account_node.freezed.dart';
part 'account_node.g.dart';

/// An account and its potential children.
@Freezed(makeCollectionsUnmodifiable: false)
class AccountNode with _$AccountNode {
  const factory AccountNode({
    required Account account,
    required List<AccountNode> children,
  }) = _AccountNode;

  const AccountNode._();

  factory AccountNode.fromJson(Map<String, dynamic> json) => _$AccountNodeFromJson(json);

  Iterable<AccountNode> get descendants sync* {
    for (AccountNode child in children) {
      yield child;
      yield* child.descendants;
    }
  }
}

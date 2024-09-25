import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'intro_state.freezed.dart';
part 'intro_state.g.dart';

@freezed
class IntroState with _$IntroState {
  const factory IntroState({
    @Default(0) int currentIndex,
    @Default([]) List<String> nonParsableAccounts,
  }) = _IntroState;
}

@riverpod
class IntroStateN extends _$IntroStateN {
  @override
  IntroState build() {
    return const IntroState();
  }

  set currentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
  set nonParsableAccounts(List<String> accounts) {
    state = state.copyWith(nonParsableAccounts: accounts);
  }
}

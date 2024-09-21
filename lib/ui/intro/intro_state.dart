import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'intro_state.freezed.dart';

@freezed
class IntroState with _$IntroState {
  const factory IntroState({
    required int currentIndex,
  }) = _IntroState;
}

final StateProvider<IntroState> introStateProvider = StateProvider(
  (ref) => const IntroState(currentIndex: 0),
);

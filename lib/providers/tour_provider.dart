// lib/providers/tour_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kTourCompleted = 'tour_completed';
const _kTourStep = 'tour_step';
const _kTourRestartBannerDismissed = 'tour_restart_banner_dismissed';

class TourState {
  final bool tourCompleted;
  final int currentStep; // 0 = not started, 1–13 = active step
  final bool welcomeVisible;
  final bool skipConfirmVisible;
  final bool completionVisible;
  final bool restartBannerDismissed;

  const TourState({
    this.tourCompleted = false,
    this.currentStep = 0,
    this.welcomeVisible = false,
    this.skipConfirmVisible = false,
    this.completionVisible = false,
    this.restartBannerDismissed = false,
  });

  TourState copyWith({
    bool? tourCompleted,
    int? currentStep,
    bool? welcomeVisible,
    bool? skipConfirmVisible,
    bool? completionVisible,
    bool? restartBannerDismissed,
  }) =>
      TourState(
        tourCompleted: tourCompleted ?? this.tourCompleted,
        currentStep: currentStep ?? this.currentStep,
        welcomeVisible: welcomeVisible ?? this.welcomeVisible,
        skipConfirmVisible: skipConfirmVisible ?? this.skipConfirmVisible,
        completionVisible: completionVisible ?? this.completionVisible,
        restartBannerDismissed:
            restartBannerDismissed ?? this.restartBannerDismissed,
      );
}

class TourNotifier extends AsyncNotifier<TourState> {
  @override
  Future<TourState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool(_kTourCompleted) ?? false;
    final step = prefs.getInt(_kTourStep) ?? 0;
    final restartBannerDismissed =
        prefs.getBool(_kTourRestartBannerDismissed) ?? false;
    return TourState(
      tourCompleted: completed,
      currentStep: step,
      welcomeVisible: !completed && step == 0,
      restartBannerDismissed: restartBannerDismissed,
    );
  }

  Future<void> startTour() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTourCompleted, false);
    await prefs.setInt(_kTourStep, 1);
    await prefs.setBool(_kTourRestartBannerDismissed, false);
    state = AsyncData(state.requireValue.copyWith(
      tourCompleted: false,
      welcomeVisible: false,
      currentStep: 1,
      restartBannerDismissed: false,
    ));
  }

  Future<void> nextStep() async {
    final current = state.requireValue;
    final next = current.currentStep + 1;
    final prefs = await SharedPreferences.getInstance();
    if (next > 13) {
      await prefs.setBool(_kTourCompleted, true);
      await prefs.setInt(_kTourStep, 0);
      state = AsyncData(current.copyWith(
        currentStep: 0,
        completionVisible: true,
      ));
    } else {
      await prefs.setInt(_kTourStep, next);
      state = AsyncData(current.copyWith(currentStep: next));
    }
  }

  void showSkipConfirm() =>
      state = AsyncData(state.requireValue.copyWith(skipConfirmVisible: true));

  void cancelSkip() =>
      state = AsyncData(state.requireValue.copyWith(skipConfirmVisible: false));

  Future<void> confirmSkip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTourCompleted, true);
    await prefs.setInt(_kTourStep, 0);
    state = AsyncData(state.requireValue.copyWith(
      tourCompleted: true,
      currentStep: 0,
      skipConfirmVisible: false,
    ));
  }

  Future<void> completeTour() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTourCompleted, true);
    state = AsyncData(state.requireValue.copyWith(
      tourCompleted: true,
      currentStep: 0,
      completionVisible: false,
    ));
  }

  Future<void> dismissRestartBanner() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTourRestartBannerDismissed, true);
    state = AsyncData(
      state.requireValue.copyWith(restartBannerDismissed: true),
    );
  }
}

final tourProvider = AsyncNotifierProvider<TourNotifier, TourState>(
  TourNotifier.new,
);

// Top-level constant map so GlobalKey instances are never recreated.
// Must be declared outside any provider factory to survive hot restarts.
final _tourKeys = {
  for (var i = 1; i <= 13; i++) i: GlobalKey(debugLabel: 'tourKey_$i')
};

final tourKeysProvider = Provider<Map<int, GlobalKey>>((_) => _tourKeys);

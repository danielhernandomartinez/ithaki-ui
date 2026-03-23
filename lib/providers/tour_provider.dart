// lib/providers/tour_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kTourCompleted = 'tour_completed';
const _kTourStep = 'tour_step';

class TourState {
  final bool tourCompleted;
  final int currentStep; // 0 = not started, 1–13 = active step
  final bool welcomeVisible;
  final bool skipConfirmVisible;
  final bool completionVisible;

  const TourState({
    this.tourCompleted = false,
    this.currentStep = 0,
    this.welcomeVisible = false,
    this.skipConfirmVisible = false,
    this.completionVisible = false,
  });

  TourState copyWith({
    bool? tourCompleted,
    int? currentStep,
    bool? welcomeVisible,
    bool? skipConfirmVisible,
    bool? completionVisible,
  }) =>
      TourState(
        tourCompleted: tourCompleted ?? this.tourCompleted,
        currentStep: currentStep ?? this.currentStep,
        welcomeVisible: welcomeVisible ?? this.welcomeVisible,
        skipConfirmVisible: skipConfirmVisible ?? this.skipConfirmVisible,
        completionVisible: completionVisible ?? this.completionVisible,
      );
}

class TourNotifier extends Notifier<TourState> {
  @override
  TourState build() => const TourState();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool(_kTourCompleted) ?? false;
    final step = prefs.getInt(_kTourStep) ?? 0;
    state = state.copyWith(tourCompleted: completed, currentStep: step);
    if (!completed) {
      state = state.copyWith(welcomeVisible: true);
    }
  }

  Future<void> startTour() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kTourStep, 1);
    state = state.copyWith(
      welcomeVisible: false,
      currentStep: 1,
    );
  }

  Future<void> nextStep() async {
    final next = state.currentStep + 1;
    final prefs = await SharedPreferences.getInstance();
    if (next > 13) {
      await prefs.setBool(_kTourCompleted, true);
      await prefs.setInt(_kTourStep, 0);
      state = state.copyWith(
        currentStep: 0,
        completionVisible: true,
      );
    } else {
      await prefs.setInt(_kTourStep, next);
      state = state.copyWith(currentStep: next);
    }
  }

  void showSkipConfirm() =>
      state = state.copyWith(skipConfirmVisible: true);

  void cancelSkip() =>
      state = state.copyWith(skipConfirmVisible: false);

  Future<void> confirmSkip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTourCompleted, true);
    await prefs.setInt(_kTourStep, 0);
    state = state.copyWith(
      tourCompleted: true,
      currentStep: 0,
      skipConfirmVisible: false,
    );
  }

  Future<void> completeTour() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTourCompleted, true);
    state = state.copyWith(
      tourCompleted: true,
      currentStep: 0,
      completionVisible: false,
    );
  }
}

final tourProvider = NotifierProvider<TourNotifier, TourState>(
  TourNotifier.new,
);

// Top-level constant map so GlobalKey instances are never recreated.
// Must be declared outside any provider factory to survive hot restarts.
final _tourKeys = {for (var i = 1; i <= 13; i++) i: GlobalKey(debugLabel: 'tourKey_$i')};

final tourKeysProvider = Provider<Map<int, GlobalKey>>((_) => _tourKeys);

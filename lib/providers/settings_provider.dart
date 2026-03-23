// lib/providers/settings_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final bool whatsappEnabled;
  final bool smsEnabled;
  final bool pushEnabled;
  final bool emailNewsletterActive;
  final Set<String> newsletterTypes;

  const SettingsState({
    this.whatsappEnabled = true,
    this.smsEnabled = false,
    this.pushEnabled = true,
    this.emailNewsletterActive = false,
    this.newsletterTypes = const {},
  });

  SettingsState copyWith({
    bool? whatsappEnabled, bool? smsEnabled, bool? pushEnabled,
    bool? emailNewsletterActive, Set<String>? newsletterTypes,
  }) => SettingsState(
    whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
    smsEnabled: smsEnabled ?? this.smsEnabled,
    pushEnabled: pushEnabled ?? this.pushEnabled,
    emailNewsletterActive: emailNewsletterActive ?? this.emailNewsletterActive,
    newsletterTypes: newsletterTypes ?? this.newsletterTypes,
  );
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void toggleChannel(String channel) {
    switch (channel) {
      case 'whatsapp': state = state.copyWith(whatsappEnabled: !state.whatsappEnabled);
      case 'sms':      state = state.copyWith(smsEnabled: !state.smsEnabled);
      case 'push':     state = state.copyWith(pushEnabled: !state.pushEnabled);
    }
  }

  void subscribeNewsletter() {
    state = state.copyWith(emailNewsletterActive: true);
  }

  void unsubscribeNewsletter() {
    state = state.copyWith(emailNewsletterActive: false, newsletterTypes: {});
  }

  void toggleNewsletterType(String type) {
    final current = Set<String>.from(state.newsletterTypes);
    if (current.contains(type)) {
      current.remove(type);
    } else {
      current.add(type);
    }
    state = state.copyWith(newsletterTypes: current);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationState {
  final String language;
  final String techLevel;
  final String email;
  final String password;
  final String name;
  final String lastName;
  final String phone;
  final String verifyMethod;
  final bool rememberVerifyChoice;

  const RegistrationState({
    this.language = '',
    this.techLevel = '',
    this.email = '',
    this.password = '',
    this.name = '',
    this.lastName = '',
    this.phone = '',
    this.verifyMethod = '',
    this.rememberVerifyChoice = false,
  });

  RegistrationState copyWith({
    String? language,
    String? techLevel,
    String? email,
    String? password,
    String? name,
    String? lastName,
    String? phone,
    String? verifyMethod,
    bool? rememberVerifyChoice,
  }) {
    return RegistrationState(
      language: language ?? this.language,
      techLevel: techLevel ?? this.techLevel,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      verifyMethod: verifyMethod ?? this.verifyMethod,
      rememberVerifyChoice: rememberVerifyChoice ?? this.rememberVerifyChoice,
    );
  }
}

class RegistrationNotifier extends Notifier<RegistrationState> {
  @override
  RegistrationState build() => const RegistrationState();

  void setLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void setTechLevel(String level) {
    state = state.copyWith(techLevel: level);
  }

  void setCredentials(String email, String password) {
    state = state.copyWith(email: email, password: password);
  }

  void setPersonalDetails(String name, String lastName, String phone) {
    state = state.copyWith(name: name, lastName: lastName, phone: phone);
  }

  void setVerifyMethod(String method, {bool remember = false}) {
    state = state.copyWith(verifyMethod: method, rememberVerifyChoice: remember);
  }

  void reset() {
    state = const RegistrationState();
  }
}

final registrationProvider =
    NotifierProvider<RegistrationNotifier, RegistrationState>(
  RegistrationNotifier.new,
);

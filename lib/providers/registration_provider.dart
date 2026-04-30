import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/employer_models.dart';

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
  final bool isEmployer;
  final EmployerType? employerType;

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
    this.isEmployer = false,
    this.employerType,
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
    bool? isEmployer,
    EmployerType? employerType,
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
      isEmployer: isEmployer ?? this.isEmployer,
      employerType: employerType ?? this.employerType,
    );
  }
}

class RegistrationNotifier extends Notifier<RegistrationState> {
  @override
  RegistrationState build() => const RegistrationState();

  void setLanguage(String language) =>
      state = state.copyWith(language: language);

  void setTechLevel(String level) =>
      state = state.copyWith(techLevel: level);

  void setCredentials(String email, String password) =>
      state = state.copyWith(email: email, password: password);

  void setPersonalDetails(String name, String lastName, String phone) =>
      state = state.copyWith(name: name, lastName: lastName, phone: phone);

  void setVerifyMethod(String method, {bool remember = false}) =>
      state = state.copyWith(verifyMethod: method, rememberVerifyChoice: remember);

  void setIsEmployer(bool value) =>
      state = state.copyWith(isEmployer: value);

  void setEmployerType(EmployerType type) =>
      state = state.copyWith(employerType: type);

  void reset() => state = const RegistrationState();
}

final registrationProvider =
    NotifierProvider<RegistrationNotifier, RegistrationState>(
  RegistrationNotifier.new,
);

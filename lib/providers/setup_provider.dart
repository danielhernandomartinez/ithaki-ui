import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_models.dart';

class SetupState {
  final String citizenshipCode;
  final String citizenshipLabel;
  final String residenceCode;
  final String residenceLabel;
  final String role;
  final String relocation;
  final List<JobInterest> jobInterests;
  final String positionLevel;
  final Set<String> jobTypes;
  final Set<String> workplaceFormats;
  final String salary;
  final String paymentTerm;
  final bool preferNotToSpecifySalary;
  final Set<String> values;
  final Set<String> communicationChannels;
  final bool receiveTips;

  const SetupState({
    this.citizenshipCode = '',
    this.citizenshipLabel = '',
    this.residenceCode = '',
    this.residenceLabel = '',
    this.role = '',
    this.relocation = '',
    this.jobInterests = const [],
    this.positionLevel = '',
    this.jobTypes = const {},
    this.workplaceFormats = const {},
    this.salary = '',
    this.paymentTerm = '',
    this.preferNotToSpecifySalary = false,
    this.values = const {},
    this.communicationChannels = const {},
    this.receiveTips = false,
  });

  SetupState copyWith({
    String? citizenshipCode,
    String? citizenshipLabel,
    String? residenceCode,
    String? residenceLabel,
    String? role,
    String? relocation,
    List<JobInterest>? jobInterests,
    String? positionLevel,
    Set<String>? jobTypes,
    Set<String>? workplaceFormats,
    String? salary,
    String? paymentTerm,
    bool? preferNotToSpecifySalary,
    Set<String>? values,
    Set<String>? communicationChannels,
    bool? receiveTips,
  }) {
    return SetupState(
      citizenshipCode: citizenshipCode ?? this.citizenshipCode,
      citizenshipLabel: citizenshipLabel ?? this.citizenshipLabel,
      residenceCode: residenceCode ?? this.residenceCode,
      residenceLabel: residenceLabel ?? this.residenceLabel,
      role: role ?? this.role,
      relocation: relocation ?? this.relocation,
      jobInterests: jobInterests ?? this.jobInterests,
      positionLevel: positionLevel ?? this.positionLevel,
      jobTypes: jobTypes ?? this.jobTypes,
      workplaceFormats: workplaceFormats ?? this.workplaceFormats,
      salary: salary ?? this.salary,
      paymentTerm: paymentTerm ?? this.paymentTerm,
      preferNotToSpecifySalary: preferNotToSpecifySalary ?? this.preferNotToSpecifySalary,
      values: values ?? this.values,
      communicationChannels: communicationChannels ?? this.communicationChannels,
      receiveTips: receiveTips ?? this.receiveTips,
    );
  }
}

class SetupNotifier extends Notifier<SetupState> {
  @override
  SetupState build() => const SetupState();

  void setLocation({
    required String citizenshipCode,
    required String citizenshipLabel,
    required String residenceCode,
    required String residenceLabel,
    String? role,
    String? relocation,
  }) {
    state = state.copyWith(
      citizenshipCode: citizenshipCode,
      citizenshipLabel: citizenshipLabel,
      residenceCode: residenceCode,
      residenceLabel: residenceLabel,
      role: role ?? state.role,
      relocation: relocation ?? state.relocation,
    );
  }

  void setJobInterests(List<JobInterest> interests) {
    state = state.copyWith(jobInterests: interests);
  }

  void setPreferences({
    String? positionLevel,
    Set<String>? jobTypes,
    Set<String>? workplaceFormats,
    String? salary,
    String? paymentTerm,
    bool? preferNotToSpecifySalary,
  }) {
    state = state.copyWith(
      positionLevel: positionLevel ?? state.positionLevel,
      jobTypes: jobTypes ?? state.jobTypes,
      workplaceFormats: workplaceFormats ?? state.workplaceFormats,
      salary: salary ?? state.salary,
      paymentTerm: paymentTerm ?? state.paymentTerm,
      preferNotToSpecifySalary: preferNotToSpecifySalary ?? state.preferNotToSpecifySalary,
    );
  }

  void setValues(Set<String> values) {
    state = state.copyWith(values: values);
  }

  void setCommunication(Set<String> channels, bool receiveTips) {
    state = state.copyWith(
      communicationChannels: channels,
      receiveTips: receiveTips,
    );
  }

  void reset() {
    state = const SetupState();
  }
}

final setupProvider = NotifierProvider<SetupNotifier, SetupState>(
  SetupNotifier.new,
);

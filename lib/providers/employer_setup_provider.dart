import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/employer_models.dart';

class EmployerSetupNotifier extends Notifier<EmployerSetupState> {
  @override
  EmployerSetupState build() => const EmployerSetupState();

  void setType(EmployerType type) =>
      state = state.copyWith(type: type);

  void setAdminDetails({
    required String name,
    required String lastName,
    required String phone,
    required String role,
  }) =>
      state = state.copyWith(
        adminName: name,
        adminLastName: lastName,
        adminPhone: phone,
        adminRole: role,
      );

  void setCompanyDetails({
    required String legalName,
    required String industry,
    required String companySize,
  }) =>
      state = state.copyWith(
        legalName: legalName,
        industry: industry,
        companySize: companySize,
      );

  void setContactDetails({
    required String address,
    required String city,
    required String contactEmail,
    required String contactPhone,
    String website = '',
  }) =>
      state = state.copyWith(
        address: address,
        city: city,
        contactEmail: contactEmail,
        contactPhone: contactPhone,
        website: website,
      );

  void setBranding({String? logoPath, required String aboutCompany}) =>
      state = state.copyWith(
        logoPath: logoPath,
        aboutCompany: aboutCompany,
      );

  void setValues(Set<String> values) =>
      state = state.copyWith(values: values);

  void reset() => state = const EmployerSetupState();
}

final employerSetupProvider =
    NotifierProvider<EmployerSetupNotifier, EmployerSetupState>(
  EmployerSetupNotifier.new,
);

enum EmployerType { employerCompany, ngo }

class EmployerSetupState {
  final String adminName;
  final String adminLastName;
  final String adminPhone;
  final String adminRole;
  final String legalName;
  final String industry;
  final String companySize;
  final String address;
  final String city;
  final String contactEmail;
  final String contactPhone;
  final String website;
  final String? logoPath;
  final String aboutCompany;
  final Set<String> values;
  final EmployerType type;

  const EmployerSetupState({
    this.adminName = '',
    this.adminLastName = '',
    this.adminPhone = '',
    this.adminRole = '',
    this.legalName = '',
    this.industry = '',
    this.companySize = '',
    this.address = '',
    this.city = '',
    this.contactEmail = '',
    this.contactPhone = '',
    this.website = '',
    this.logoPath,
    this.aboutCompany = '',
    this.values = const {},
    this.type = EmployerType.employerCompany,
  });

  EmployerSetupState copyWith({
    String? adminName,
    String? adminLastName,
    String? adminPhone,
    String? adminRole,
    String? legalName,
    String? industry,
    String? companySize,
    String? address,
    String? city,
    String? contactEmail,
    String? contactPhone,
    String? website,
    String? logoPath,
    String? aboutCompany,
    Set<String>? values,
    EmployerType? type,
  }) {
    return EmployerSetupState(
      adminName: adminName ?? this.adminName,
      adminLastName: adminLastName ?? this.adminLastName,
      adminPhone: adminPhone ?? this.adminPhone,
      adminRole: adminRole ?? this.adminRole,
      legalName: legalName ?? this.legalName,
      industry: industry ?? this.industry,
      companySize: companySize ?? this.companySize,
      address: address ?? this.address,
      city: city ?? this.city,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      website: website ?? this.website,
      logoPath: logoPath ?? this.logoPath,
      aboutCompany: aboutCompany ?? this.aboutCompany,
      values: values ?? this.values,
      type: type ?? this.type,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/employer_setup_provider.dart';
import '../../routes.dart';
import '../../widgets/city_search_bottom_sheet.dart';
import '../../widgets/upload_files_sheet.dart';

const _adminRoles = [
  'CEO / Founder',
  'HR Manager',
  'Recruiter',
  'Operations Manager',
  'Other',
];

const _industries = [
  'Technology',
  'Healthcare',
  'Education',
  'Finance',
  'Retail',
  'Manufacturing',
  'Non-profit',
  'Other',
];

const _companySizes = [
  '1–10',
  '11–50',
  '51–200',
  '201–500',
  '500+',
];

List<SearchItem> _toSearchItems(List<String> items) =>
    items.map((e) => SearchItem(id: e, label: e)).toList();

class EmployerSetupScreen extends ConsumerStatefulWidget {
  const EmployerSetupScreen({super.key});

  @override
  ConsumerState<EmployerSetupScreen> createState() =>
      _EmployerSetupScreenState();
}

class _EmployerSetupScreenState extends ConsumerState<EmployerSetupScreen> {
  int _currentTab = 0;

  // Tab 0 — Admin Details
  final _nameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _adminRole;

  // Tab 1 — Company Details
  final _legalNameCtrl = TextEditingController();
  String? _industry;
  String? _companySize;

  // Tab 2 — Contact Details
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  String _city = '';
  final _contactEmailCtrl = TextEditingController();
  final _contactPhoneCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();

  // Tab 3 — Profile & Branding
  final _aboutCtrl = TextEditingController();
  String? _logoPath;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _legalNameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _contactEmailCtrl.dispose();
    _contactPhoneCtrl.dispose();
    _websiteCtrl.dispose();
    _aboutCtrl.dispose();
    super.dispose();
  }

  bool get _tab0Valid =>
      _nameCtrl.text.trim().isNotEmpty &&
      _lastNameCtrl.text.trim().isNotEmpty &&
      _phoneCtrl.text.trim().isNotEmpty &&
      _adminRole != null;

  bool get _tab1Valid =>
      _legalNameCtrl.text.trim().isNotEmpty &&
      _industry != null &&
      _companySize != null;

  bool get _tab2Valid =>
      _addressCtrl.text.trim().isNotEmpty &&
      _city.isNotEmpty &&
      _contactEmailCtrl.text.contains('@') &&
      _contactPhoneCtrl.text.trim().isNotEmpty;

  bool get _currentTabValid => switch (_currentTab) {
        0 => _tab0Valid,
        1 => _tab1Valid,
        2 => _tab2Valid,
        _ => true,
      };

  void _saveAndAdvance() {
    final notifier = ref.read(employerSetupProvider.notifier);
    switch (_currentTab) {
      case 0:
        notifier.setAdminDetails(
          name: _nameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          role: _adminRole!,
        );
      case 1:
        notifier.setCompanyDetails(
          legalName: _legalNameCtrl.text.trim(),
          industry: _industry!,
          companySize: _companySize!,
        );
      case 2:
        notifier.setContactDetails(
          address: _addressCtrl.text.trim(),
          city: _city,
          contactEmail: _contactEmailCtrl.text.trim(),
          contactPhone: _contactPhoneCtrl.text.trim(),
          website: _websiteCtrl.text.trim(),
        );
      case 3:
        notifier.setBranding(
          logoPath: _logoPath,
          aboutCompany: _aboutCtrl.text.trim(),
        );
        context.push(Routes.employerSetupValues);
        return;
    }
    setState(() => _currentTab++);
  }

  void _openPicker(String title, List<String> options, ValueChanged<String> onSelected) {
    SearchBottomSheet.show(
      context,
      title,
      _toSearchItems(options),
      (item) => onSelected(item.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final tabs = [
      l.employerSetupAdminTab,
      l.employerSetupCompanyTab,
      l.employerSetupContactsTab,
      l.employerSetupBrandingTab,
    ];

    return IthakiScreenLayout(
      appBar: const IthakiAppBar(showMenuAndAvatar: false),
      horizontalPadding: 0,
      verticalPadding: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IthakiStepTabs(
            steps: tabs,
            currentIndex: _currentTab,
            completedUpTo: _currentTab - 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: _buildTabContent(l),
            ),
          ),
          _buildButtons(l),
        ],
      ),
    );
  }

  Widget _buildTabContent(AppLocalizations l) {
    return switch (_currentTab) {
      0 => _buildAdminTab(l),
      1 => _buildCompanyTab(l),
      2 => _buildContactsTab(l),
      _ => _buildBrandingTab(l),
    };
  }

  Widget _buildAdminTab(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.employerAdminHeading, style: IthakiTheme.headingLarge),
        const SizedBox(height: 8),
        Text(l.employerAdminDescription, style: IthakiTheme.bodyRegular),
        const SizedBox(height: 24),
        IthakiTextField(
          label: l.nameLabel,
          hint: l.nameHint,
          controller: _nameCtrl,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        IthakiTextField(
          label: l.lastNameLabel,
          hint: l.lastNameHint,
          controller: _lastNameCtrl,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        IthakiTextField(
          label: l.phoneNumberLabel,
          hint: '+XX XXX XXX XX XX',
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        IthakiSelectorField(
          label: l.adminRoleLabel,
          hint: l.adminRoleHint,
          value: _adminRole,
          onTap: () => _openPicker(l.adminRoleLabel, _adminRoles, (v) {
            setState(() => _adminRole = v);
          }),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCompanyTab(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.employerCompanyHeading, style: IthakiTheme.headingLarge),
        const SizedBox(height: 8),
        Text(l.employerCompanyDescription, style: IthakiTheme.bodyRegular),
        const SizedBox(height: 24),
        IthakiTextField(
          label: l.legalCompanyNameLabel,
          hint: l.legalCompanyNameHint,
          controller: _legalNameCtrl,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        IthakiSelectorField(
          label: l.businessIndustryLabel,
          hint: l.businessIndustryHint,
          value: _industry,
          onTap: () => _openPicker(l.businessIndustryLabel, _industries, (v) {
            setState(() => _industry = v);
          }),
        ),
        const SizedBox(height: 16),
        IthakiSelectorField(
          label: l.companySizeLabel,
          hint: l.companySizeHint,
          value: _companySize,
          onTap: () => _openPicker(l.companySizeLabel, _companySizes, (v) {
            setState(() => _companySize = v);
          }),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildContactsTab(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.employerContactsHeading, style: IthakiTheme.headingLarge),
        const SizedBox(height: 8),
        Text(l.employerContactsDescription, style: IthakiTheme.bodyRegular),
        const SizedBox(height: 24),
        IthakiTextField(
          label: l.registeredAddressLabel,
          hint: l.registeredAddressHint,
          controller: _addressCtrl,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        IthakiTextField(
          label: l.cityLabel,
          hint: l.cityHint,
          controller: _cityCtrl,
          readOnly: true,
          suffixIcon: const Padding(
            padding: EdgeInsets.all(12),
            child: IthakiIcon('flag', size: 20, color: IthakiTheme.softGraphite),
          ),
          onTap: () => CitySearchBottomSheet.show(
            context,
            (city) => setState(() {
              _city = city;
              _cityCtrl.text = city;
            }),
          ),
        ),
        const SizedBox(height: 16),
        IthakiTextField(
          label: l.contactEmailLabel,
          hint: l.contactEmailHint,
          controller: _contactEmailCtrl,
          keyboardType: TextInputType.emailAddress,
          suffixIcon: const Padding(
            padding: EdgeInsets.all(12),
            child: IthakiIcon('envelope', size: 20, color: IthakiTheme.softGraphite),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 4),
        Text(l.contactEmailHelper,
            style: const TextStyle(fontSize: 12, color: IthakiTheme.textSecondary)),
        const SizedBox(height: 12),
        IthakiTextField(
          label: l.contactPhoneLabel,
          hint: l.contactPhoneHint,
          controller: _contactPhoneCtrl,
          keyboardType: TextInputType.phone,
          suffixIcon: const Padding(
            padding: EdgeInsets.all(12),
            child: IthakiIcon('phone', size: 20, color: IthakiTheme.softGraphite),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 4),
        Text(l.contactPhoneHelper,
            style: const TextStyle(fontSize: 12, color: IthakiTheme.textSecondary)),
        const SizedBox(height: 12),
        IthakiTextField(
          label: l.companyWebsiteLabel,
          hint: l.companyWebsiteHint,
          controller: _websiteCtrl,
          keyboardType: TextInputType.url,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBrandingTab(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.employerBrandingHeading, style: IthakiTheme.headingLarge),
        const SizedBox(height: 8),
        Text(l.employerBrandingDescription, style: IthakiTheme.bodyRegular),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.push(Routes.employerSetupValues),
          child: Text(
            l.skipForNow,
            style: IthakiTheme.bodyRegular
                .copyWith(decoration: TextDecoration.underline),
          ),
        ),
        const SizedBox(height: 16),
        Text(l.uploadPhotoLabel, style: IthakiTheme.sectionTitle),
        const SizedBox(height: 8),
        Text(l.uploadPhotoDescription,
            style: const TextStyle(fontSize: 12, color: IthakiTheme.textSecondary)),
        const SizedBox(height: 12),
        IthakiButton(
          l.uploadPhotoLabel,
          variant: IthakiButtonVariant.outline,
          onPressed: () {
            UploadFilesSheet.show(context, onContinue: (files) {
              if (files.isNotEmpty) {
                setState(() => _logoPath = files.first.name);
              }
            });
          },
        ),
        if (_logoPath != null) ...[
          const SizedBox(height: 8),
          Text(_logoPath!,
              style: const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary)),
        ],
        const SizedBox(height: 24),
        Text(l.aboutCompanyLabel, style: IthakiTheme.sectionTitle),
        const SizedBox(height: 8),
        Text(l.aboutCompanyDescription, style: IthakiTheme.bodyRegular),
        const SizedBox(height: 12),
        TextField(
          controller: _aboutCtrl,
          maxLines: null,
          minLines: 6,
          maxLength: 1000,
          buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$currentLength / 1000',
                  style: const TextStyle(fontSize: 12, color: IthakiTheme.textSecondary),
                ),
              ),
          decoration: InputDecoration(
            hintText: l.aboutCompanyHint,
            hintStyle: const TextStyle(color: IthakiTheme.softGraphite),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: IthakiTheme.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: IthakiTheme.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: IthakiTheme.primaryPurple, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildButtons(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          IthakiButton(
            l.continueButton,
            isEnabled: _currentTabValid,
            onPressed: _currentTabValid ? _saveAndAdvance : null,
          ),
          if (_currentTab > 0) ...[
            const SizedBox(height: 12),
            IthakiButton(
              l.backButton,
              variant: IthakiButtonVariant.outline,
              onPressed: () => setState(() => _currentTab--),
            ),
          ],
        ],
      ),
    );
  }
}

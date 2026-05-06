import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../data/countries.dart';
import '../../l10n/app_localizations.dart';
import '../../routes.dart';
import '../../utils/validators.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/panel_scaffold.dart';
import '../../widgets/profile_picker_field.dart';
import '../../widgets/profile_photo_section.dart';

class ProfileBasicsScreen extends ConsumerStatefulWidget {
  const ProfileBasicsScreen({super.key});

  @override
  ConsumerState<ProfileBasicsScreen> createState() =>
      _ProfileBasicsScreenState();
}

class _ProfileBasicsScreenState extends ConsumerState<ProfileBasicsScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _dobCtrl;
  late TextEditingController _citizenshipCtrl;
  late TextEditingController _residenceCtrl;
  String _citizenshipCode = '';
  String _residenceCode = '';
  String _gender = '';
  String _status = '';
  String _relocation = '';
  String? _photoPath;
  bool _isDirty = false;

  static const _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];
  static const _statusOptions = ['Migrant', 'Refugee', 'Asylum Seeker'];
  static const _relocationOptions = [
    'Not willing to relocate',
    'Willing to relocate locally',
    'Willing to relocate nationally',
    'Willing to relocate internationally',
  ];

  @override
  void initState() {
    super.initState();
    final basics = ref.read(profileBasicsProvider).requireValue;
    _nameCtrl = TextEditingController(text: basics.firstName);
    _lastNameCtrl = TextEditingController(text: basics.lastName);
    _dobCtrl = TextEditingController(text: basics.dateOfBirth);
    _citizenshipCtrl = TextEditingController(text: basics.citizenship);
    _residenceCtrl = TextEditingController(text: basics.residence);
    _citizenshipCode = basics.citizenshipCode;
    _residenceCode = basics.residenceCode;
    _gender = basics.gender;
    _status = _statusOptions.contains(basics.status) ? basics.status : '';
    _relocation = basics.relocationReadiness;
    _photoPath = basics.photoUrl;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _dobCtrl.dispose();
    _citizenshipCtrl.dispose();
    _residenceCtrl.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _nameCtrl.text.trim().isNotEmpty && _lastNameCtrl.text.trim().isNotEmpty;

  void _markDirty() => setState(() => _isDirty = true);

  void _onBack() {
    if (_isDirty) {
      _showLeaveSheet();
    } else {
      context.pop();
    }
  }

  Future<void> _save() async {
    try {
      await ref.read(profileBasicsProvider.notifier).save(
            firstName: _nameCtrl.text.trim(),
            lastName: _lastNameCtrl.text.trim(),
            dateOfBirth: _dobCtrl.text.trim(),
            gender: _gender,
            citizenship: _citizenshipCtrl.text.trim(),
            citizenshipCode:
                _citizenshipCode.isNotEmpty ? _citizenshipCode : null,
            residence: _residenceCtrl.text.trim(),
            residenceCode: _residenceCode.isNotEmpty ? _residenceCode : null,
            status: _status,
            relocationReadiness: _relocation,
            photoUrl: _photoPath,
          );
      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (exceedsMaxFileSize(file.size)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.fileExceedsLimit)),
        );
      }
      return;
    }
    setState(() {
      _photoPath = file.path;
      _isDirty = true;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      final formatted =
          '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      _dobCtrl.text = formatted;
      _markDirty();
    }
  }

  void _openCountryPicker(
    String title,
    TextEditingController ctrl,
    ValueChanged<String> onCode,
  ) {
    SearchBottomSheet.show(
      context,
      title,
      allCountries,
      (item) => setState(() {
        ctrl.text = item.label;
        onCode(item.id);
        _isDirty = true;
      }),
    );
  }

  void _openSelectorSheet(
    String title,
    List<String> options,
    String? current,
    ValueChanged<String> onSelect,
  ) {
    final items = options.map((o) => SearchItem(id: o, label: o)).toList();
    SearchBottomSheet.show(
      context,
      title,
      items,
      (item) => setState(() {
        onSelect(item.label);
        _isDirty = true;
      }),
    );
  }

  void _showLeaveSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BottomSheetBase(
        title: AppLocalizations.of(context)!.leaveEditingTitle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.leaveEditingMessage,
              style: const TextStyle(
                  fontSize: 14, color: IthakiTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: IthakiTheme.borderLight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: IthakiTheme.textPrimary,
                ),
                child: Text(AppLocalizations.of(context)!.leaveWithoutSaving),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: IthakiButton(AppLocalizations.of(context)!.saveAndLeave,
                  onPressed: () {
                _save();
                Navigator.of(context).pop();
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isDirty) _showLeaveSheet();
      },
      child: Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        extendBodyBehindAppBar: true,
        appBar: ProfileEditAppBar(
          avatarInitials:
              '${_nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim()[0] : '?'}'
              '${_lastNameCtrl.text.trim().isNotEmpty ? _lastNameCtrl.text.trim()[0] : '?'}',
          avatarUrl: _photoPath,
          onNotificationsTap: () => context.push(Routes.settingsNotifications),
          onBack: _onBack,
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: MediaQuery.paddingOf(context).top + kToolbarHeight + 24,
              bottom: MediaQuery.viewPaddingOf(context).bottom + 16,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: IthakiTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Photo ──────────────────────────────────────────
                  ProfilePhotoSection(
                    photoPath: _photoPath,
                    onPick: _pickPhoto,
                  ),
                  const SizedBox(height: 20),

                  // ── Fields ─────────────────────────────────────────
                  IthakiTextField(
                    label: l.nameLabel,
                    hint: l.yourFirstNameHint,
                    controller: _nameCtrl,
                    onChanged: (_) => _markDirty(),
                  ),
                  const SizedBox(height: 12),
                  IthakiTextField(
                    label: l.lastNameLabel,
                    hint: l.yourLastNameHint,
                    controller: _lastNameCtrl,
                    onChanged: (_) => _markDirty(),
                  ),
                  const SizedBox(height: 12),
                  IthakiTextField(
                    label: l.dateOfBirthLabel,
                    hint: l.mmYyyyHint,
                    controller: _dobCtrl,
                    readOnly: true,
                    onTap: _pickDate,
                    suffixIcon: const IthakiIcon('calendar',
                        size: 16, color: IthakiTheme.softGraphite),
                  ),
                  const SizedBox(height: 12),
                  ProfilePickerField(
                    label: l.genderLabel,
                    hint: l.selectGender,
                    value: _gender,
                    onTap: () => _openSelectorSheet(
                      l.genderLabel,
                      _genderOptions,
                      _gender.isEmpty ? null : _gender,
                      (v) => _gender = v,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Citizenship with flag
                  IthakiTextField(
                    label: l.citizenshipLabel,
                    hint: l.selectCountry,
                    controller: _citizenshipCtrl,
                    readOnly: true,
                    onTap: () => _openCountryPicker(
                      l.citizenshipLabel,
                      _citizenshipCtrl,
                      (code) => _citizenshipCode = code,
                    ),
                    suffixIcon: _citizenshipCode.isNotEmpty
                        ? IthakiFlag(_citizenshipCode, width: 24, height: 18)
                        : const IthakiIcon('flag',
                            size: 16, color: IthakiTheme.softGraphite),
                  ),
                  const SizedBox(height: 12),
                  // Residence with flag
                  IthakiTextField(
                    label: l.residenceLabel,
                    hint: l.selectCountry,
                    controller: _residenceCtrl,
                    readOnly: true,
                    onTap: () => _openCountryPicker(
                      l.residenceLabel,
                      _residenceCtrl,
                      (code) => _residenceCode = code,
                    ),
                    suffixIcon: _residenceCode.isNotEmpty
                        ? IthakiFlag(_residenceCode, width: 24, height: 18)
                        : const IthakiIcon('flag',
                            size: 16, color: IthakiTheme.softGraphite),
                  ),
                  const SizedBox(height: 12),
                  ProfilePickerField(
                    label: l.statusLabel,
                    hint: l.selectStatus,
                    value: _status,
                    onTap: () => _openSelectorSheet(
                      l.statusLabel,
                      _statusOptions,
                      _status.isEmpty ? null : _status,
                      (v) => _status = v,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProfilePickerField(
                    label: l.relocationReadinessLabel,
                    hint: l.selectOption,
                    value: _relocation,
                    onTap: () => _openSelectorSheet(
                      l.relocationReadinessLabel,
                      _relocationOptions,
                      _relocation.isEmpty ? null : _relocation,
                      (v) => _relocation = v,
                    ),
                  ),
                  const SizedBox(height: 24),
                  IthakiButton(l.save, onPressed: _isFormValid ? _save : null),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

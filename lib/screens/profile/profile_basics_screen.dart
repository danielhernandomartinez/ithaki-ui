import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/profile_provider.dart';

class ProfileBasicsScreen extends ConsumerStatefulWidget {
  const ProfileBasicsScreen({super.key});

  @override
  ConsumerState<ProfileBasicsScreen> createState() => _ProfileBasicsScreenState();
}

class _ProfileBasicsScreenState extends ConsumerState<ProfileBasicsScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _dobCtrl;
  late TextEditingController _citizenshipCtrl;
  late TextEditingController _residenceCtrl;
  String _gender = '';
  String _status = '';
  String _relocation = '';
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    _nameCtrl = TextEditingController(text: profile.firstName);
    _lastNameCtrl = TextEditingController(text: profile.lastName);
    _dobCtrl = TextEditingController(text: profile.dateOfBirth);
    _citizenshipCtrl = TextEditingController(text: profile.citizenship);
    _residenceCtrl = TextEditingController(text: profile.residence);
    _gender = profile.gender;
    _status = profile.status;
    _relocation = profile.relocationReadiness;
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

  void _onBack() {
    if (_isDirty) {
      _showLeaveSheet();
    } else {
      context.pop();
    }
  }

  void _save() {
    ref.read(profileProvider.notifier).updateBasics(
      firstName: _nameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      dateOfBirth: _dobCtrl.text.trim(),
      gender: _gender,
      citizenship: _citizenshipCtrl.text.trim(),
      residence: _residenceCtrl.text.trim(),
      status: _status,
      relocationReadiness: _relocation,
    );
    context.pop();
  }

  void _showLeaveSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BottomSheetBase(
        title: 'Leave Editing?',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'All entered information will be lost if you leave this screen.',
              style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close sheet
                  context.pop(); // leave screen
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: IthakiTheme.textPrimary,
                ),
                child: const Text('Leave without saving'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: IthakiButton('Save and Leave', onPressed: () {
                _save();
                Navigator.of(context).pop();
                context.pop();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labeledField(String label, TextEditingController ctrl) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            onChanged: (_) => setState(() => _isDirty = true),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: IthakiTheme.primaryPurple)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      );

  Widget _dateField(String label, TextEditingController ctrl) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(1995),
                firstDate: DateTime(1940),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                final formatted =
                    '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
                ctrl.text = formatted;
                setState(() => _isDirty = true);
              }
            },
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.calendar_today_outlined,
                  size: 18, color: IthakiTheme.softGraphite),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: IthakiTheme.primaryPurple)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      );

  Widget _dropdownField(String label, String value, List<String> options,
          void Function(String?) onChanged) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 6),
          InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: IthakiTheme.primaryPurple)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: DropdownButton<String>(
              value: value.isNotEmpty ? value : null,
              onChanged: onChanged,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: options
                  .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isDirty) _showLeaveSheet();
      },
      child: Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        appBar: IthakiAppBar(
          showBackButton: true,
          title: 'Profile Basics',
          onMenuPressed: _onBack,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Profile Basics',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: IthakiTheme.textPrimary)),
                const SizedBox(height: 4),
                const Text('Update your basic information.',
                    style: TextStyle(
                        fontSize: 14, color: IthakiTheme.textSecondary)),
                const SizedBox(height: 20),

                // Upload photo section
                Row(children: [
                  const CircleAvatar(
                      radius: 32,
                      backgroundColor: IthakiTheme.primaryPurple,
                      child:
                          Icon(Icons.person, color: Colors.white, size: 32)),
                  const SizedBox(width: 12),
                  const Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                            '5 Mb max, supported formats: .png, .jpg',
                            style: TextStyle(
                                fontSize: 12,
                                color: IthakiTheme.textSecondary)),
                        SizedBox(height: 4),
                        Text(
                            'We recommend a professional photo that clearly shows your face.',
                            style: TextStyle(
                                fontSize: 12,
                                color: IthakiTheme.textSecondary)),
                      ])),
                ]),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      foregroundColor: IthakiTheme.textPrimary,
                    ),
                    child: const Text('↺ Replace'),
                  ),
                ),
                const SizedBox(height: 20),

                // Form fields
                _labeledField('Name', _nameCtrl),
                const SizedBox(height: 12),
                _labeledField('Last Name', _lastNameCtrl),
                const SizedBox(height: 12),
                _dateField('Date of Birth', _dobCtrl),
                const SizedBox(height: 12),
                _dropdownField(
                    'Gender',
                    _gender,
                    ['Male', 'Female', 'Other', 'Prefer not to say'],
                    (v) => setState(() {
                          _gender = v!;
                          _isDirty = true;
                        })),
                const SizedBox(height: 12),
                _labeledField('Citizenship', _citizenshipCtrl),
                const SizedBox(height: 12),
                _labeledField('Residence', _residenceCtrl),
                const SizedBox(height: 12),
                _dropdownField(
                    'Status',
                    _status,
                    ['Citizen', 'Permanent Resident', 'Work Visa', 'Student'],
                    (v) => setState(() {
                          _status = v!;
                          _isDirty = true;
                        })),
                const SizedBox(height: 12),
                _dropdownField(
                    'Relocation Readiness',
                    _relocation,
                    ['Yes', 'No', 'Open to discuss'],
                    (v) => setState(() {
                          _relocation = v!;
                          _isDirty = true;
                        })),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: IthakiButton('Save',
                      onPressed: _isFormValid ? _save : null),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../data/countries.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

final _roles = [
  const SearchItem(id: 'citizen', label: 'Citizen'),
  const SearchItem(id: 'resident', label: 'Resident'),
  const SearchItem(id: 'work_permit', label: 'Work Permit'),
  const SearchItem(id: 'student', label: 'Student'),
  const SearchItem(id: 'freelancer', label: 'Freelancer'),
  const SearchItem(id: 'job_seeker', label: 'Job Seeker'),
  const SearchItem(id: 'expat', label: 'Expat'),
];

final _relocationOptions = [
  const SearchItem(id: 'yes', label: 'Yes, ready to relocate'),
  const SearchItem(id: 'no', label: 'No, not looking to relocate'),
  const SearchItem(id: 'open', label: 'Open to it'),
  const SearchItem(id: 'remote_only', label: 'Remote only'),
  const SearchItem(id: 'within_country', label: 'Within my country only'),
];

class _LocationScreenState extends State<LocationScreen> {
  final _citizenshipController = TextEditingController();
  final _residenceController = TextEditingController();
  String? _citizenshipCode;
  String? _residenceCode;
  String? _role;
  String? _relocation;

  @override
  void dispose() {
    _citizenshipController.dispose();
    _residenceController.dispose();
    super.dispose();
  }

  void _openCountryPicker(TextEditingController controller, String title, ValueChanged<String> onCode) {
    SearchBottomSheet.show(
      context,
      title,
      allCountries,
      (item) => setState(() {
        controller.text = item.label;
        onCode(item.id);
      }),
    );
  }

  void _openRolePicker() {
    SearchBottomSheet.show(
      context,
      'Work Authorization',
      _roles,
      (item) => setState(() => _role = item.label),
    );
  }

  void _openRelocationPicker() {
    SearchBottomSheet.show(
      context,
      'Relocation Readiness',
      _relocationOptions,
      (item) => setState(() => _relocation = item.label),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IthakiAppBar(showMenuAndAvatar: true),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IthakiStepTabs(
              steps: ['Location', 'Job Interests', 'Preferences', 'Values', 'Communication'],
              currentIndex: 0,
              completedUpTo: -1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Location', style: IthakiTheme.headingLarge),
                  const SizedBox(height: 8),
                  const Text(
                    'Select a location to narrow down relevant job opportunities.',
                    style: IthakiTheme.bodyRegular,
                  ),
                  const SizedBox(height: 24),
                  IthakiTextField(
                    label: 'Citizenship',
                    hint: 'Select a country or type to search',
                    controller: _citizenshipController,
                    suffixIcon: _citizenshipCode != null
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: IthakiFlag(_citizenshipCode!, width: 24, height: 18),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(12),
                            child: IthakiIcon('flag', size: 18, color: IthakiTheme.textHint),
                          ),
                    readOnly: true,
                    onTap: () => _openCountryPicker(_citizenshipController, 'Citizenship', (code) => _citizenshipCode = code),
                  ),
                  const SizedBox(height: 16),
                  IthakiTextField(
                    label: 'Residence',
                    hint: 'Select a country or type to search',
                    controller: _residenceController,
                    suffixIcon: _residenceCode != null
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: IthakiFlag(_residenceCode!, width: 24, height: 18),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(12),
                            child: IthakiIcon('flag', size: 18, color: IthakiTheme.textHint),
                          ),
                    readOnly: true,
                    onTap: () => _openCountryPicker(_residenceController, 'Residence', (code) => _residenceCode = code),
                  ),
                  const SizedBox(height: 16),
                  IthakiSelectorField(
                    label: 'Work Authorization',
                    value: _role,
                    hint: 'Select your status',
                    onTap: _openRolePicker,
                  ),
                  const SizedBox(height: 16),
                  IthakiSelectorField(
                    label: 'Relocation Readiness',
                    value: _relocation,
                    hint: 'Select your relocation preference',
                    onTap: _openRelocationPicker,
                  ),
                  const SizedBox(height: 40),
                  IthakiButton(
                    'Continue',
                    onPressed: _residenceCode != null ? () => context.go('/setup/job-interests') : null,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

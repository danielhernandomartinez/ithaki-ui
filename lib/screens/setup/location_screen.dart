import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../data/countries.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/setup_provider.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
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

  void _openRolePicker(AppLocalizations l, List<SearchItem> roles) {
    SearchBottomSheet.show(
      context,
      l.workAuthorizationLabel,
      roles,
      (item) => setState(() => _role = item.label),
    );
  }

  void _openRelocationPicker(AppLocalizations l, List<SearchItem> relocationOptions) {
    SearchBottomSheet.show(
      context,
      l.relocationLabel,
      relocationOptions,
      (item) => setState(() => _relocation = item.label),
    );
  }


  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final roles = [
      SearchItem(id: 'citizen', label: l.roleCitizen),
      SearchItem(id: 'resident', label: l.roleResident),
      SearchItem(id: 'work_permit', label: l.roleWorkPermit),
      SearchItem(id: 'student', label: l.roleStudent),
      SearchItem(id: 'freelancer', label: l.roleFreelancer),
      SearchItem(id: 'job_seeker', label: l.roleJobSeeker),
      SearchItem(id: 'expat', label: l.roleExpat),
    ];

    final relocationOptions = [
      SearchItem(id: 'yes', label: l.relocationYes),
      SearchItem(id: 'no', label: l.relocationNo),
      SearchItem(id: 'open', label: l.relocationOpen),
      SearchItem(id: 'remote_only', label: l.relocationRemote),
      SearchItem(id: 'within_country', label: l.relocationWithinCountry),
    ];

    final topOffset = MediaQuery.of(context).padding.top + kToolbarHeight + 16;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const IthakiAppBar(showMenuAndAvatar: true),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
        padding: EdgeInsets.only(top: topOffset + 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IthakiStepTabs(
              steps: [l.stepLocation, l.stepJobInterests, l.stepPreferences, l.stepValues, l.stepCommunication],
              currentIndex: 0,
              completedUpTo: -1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.locationHeading, style: IthakiTheme.headingLarge),
                  const SizedBox(height: 8),
                  Text(
                    l.locationDescription,
                    style: IthakiTheme.bodyRegular,
                  ),
                  const SizedBox(height: 24),
                  IthakiTextField(
                    label: l.citizenshipLabel,
                    hint: l.citizenshipHint,
                    controller: _citizenshipController,
                    suffixIcon: _citizenshipCode != null
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: IthakiFlag(_citizenshipCode!, width: 24, height: 18),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(12),
                            child: IthakiIcon('flag', size: 20, color: _citizenshipController.text.isNotEmpty ? Colors.black : IthakiTheme.textHint),
                          ),
                    readOnly: true,
                    onTap: () => _openCountryPicker(_citizenshipController, l.citizenshipLabel, (code) => _citizenshipCode = code),
                  ),
                  const SizedBox(height: 16),
                  IthakiTextField(
                    label: l.residenceLabel,
                    hint: l.residenceHint,
                    controller: _residenceController,
                    suffixIcon: _residenceCode != null
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: IthakiFlag(_residenceCode!, width: 24, height: 18),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(12),
                            child: IthakiIcon('flag', size: 20, color: _residenceController.text.isNotEmpty ? Colors.black : IthakiTheme.textHint),
                          ),
                    readOnly: true,
                    onTap: () => _openCountryPicker(_residenceController, l.residenceLabel, (code) => _residenceCode = code),
                  ),
                  const SizedBox(height: 16),
                  IthakiSelectorField(
                    label: l.workAuthorizationLabel,
                    value: _role,
                    hint: l.workAuthorizationHint,
                    onTap: () => _openRolePicker(l, roles),
                  ),
                  const SizedBox(height: 16),
                  IthakiSelectorField(
                    label: l.relocationLabel,
                    value: _relocation,
                    hint: l.relocationHint,
                    onTap: () => _openRelocationPicker(l, relocationOptions),
                  ),
                  const SizedBox(height: 40),
                  IthakiButton(
                    l.continueButton,
                    onPressed: _residenceCode != null
                        ? () {
                            ref.read(setupProvider.notifier).setLocation(
                              citizenshipCode: _citizenshipCode ?? '',
                              citizenshipLabel: _citizenshipController.text,
                              residenceCode: _residenceCode ?? '',
                              residenceLabel: _residenceController.text,
                              role: _role,
                              relocation: _relocation,
                            );
                            context.push('/setup/job-interests');
                          }
                        : null,
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

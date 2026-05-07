import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../data/countries.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/setup_provider.dart';
import 'widgets/setup_app_bar.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(setupProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _citizenshipController.dispose();
    _residenceController.dispose();
    super.dispose();
  }

  void _openCountryPicker(TextEditingController controller, String title,
      ValueChanged<String> onCode, AppLocalizations l) {
    SearchBottomSheet.show(
      context,
      title,
      allCountries,
      (item) => setState(() {
        controller.text = item.label;
        onCode(item.id);
      }),
      searchHint: l.searchHint,
      selectLabel: l.selectAction,
    );
  }

  void _openRolePicker(AppLocalizations l, List<SearchItem> roles) {
    SearchBottomSheet.show(
      context,
      l.workAuthorizationLabel,
      roles,
      (item) => setState(() => _role = item.label),
      searchHint: l.searchHint,
      selectLabel: l.selectAction,
    );
  }

  void _openRelocationPicker(
      AppLocalizations l, List<SearchItem> relocationOptions) {
    SearchBottomSheet.show(
      context,
      l.relocationLabel,
      relocationOptions,
      (item) => setState(() => _relocation = item.label),
      searchHint: l.searchHint,
      selectLabel: l.selectAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final roles = [
      SearchItem(id: 'MIGRANT', label: l.roleMigrant),
      SearchItem(id: 'REFUGEE', label: l.roleRefugee),
      SearchItem(id: 'ASYLUM_SEEKER', label: l.roleAsylumSeeker),
    ];

    final relocationOptions = [
      SearchItem(id: 'NEGATIVE', label: l.relocationNegative),
      SearchItem(id: 'LOCALLY', label: l.relocationLocally),
      SearchItem(id: 'NATIONALLY', label: l.relocationNationally),
      SearchItem(id: 'INTERNATIONALLY', label: l.relocationInternationally),
    ];

    return IthakiScreenLayout(
      appBar: const SetupAppBar(),
      horizontalPadding: 0,
      verticalPadding: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IthakiStepTabs(
            steps: [
              l.stepLocation,
              l.stepJobInterests,
              l.stepPreferences,
              l.stepValues,
              l.stepCommunication
            ],
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
                          child: IthakiFlag(_citizenshipCode!,
                              width: 24, height: 18),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12),
                          child: IthakiIcon('flag',
                              size: 20,
                              color: _citizenshipController.text.isNotEmpty
                                  ? Colors.black
                                  : IthakiTheme.softGraphite),
                        ),
                  readOnly: true,
                  onTap: () => _openCountryPicker(_citizenshipController,
                      l.citizenshipLabel, (code) => _citizenshipCode = code, l),
                ),
                const SizedBox(height: 16),
                IthakiTextField(
                  label: l.residenceLabel,
                  hint: l.residenceHint,
                  controller: _residenceController,
                  suffixIcon: _residenceCode != null
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: IthakiFlag(_residenceCode!,
                              width: 24, height: 18),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12),
                          child: IthakiIcon('flag',
                              size: 20,
                              color: _residenceController.text.isNotEmpty
                                  ? Colors.black
                                  : IthakiTheme.softGraphite),
                        ),
                  readOnly: true,
                  onTap: () => _openCountryPicker(_residenceController,
                      l.residenceLabel, (code) => _residenceCode = code, l),
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
                          context.push(Routes.setupJobInterests);
                        }
                      : null,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

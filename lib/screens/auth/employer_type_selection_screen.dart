import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../models/employer_models.dart';
import '../../providers/employer_setup_provider.dart';
import '../../providers/registration_provider.dart';
import '../../routes.dart';

class EmployerTypeSelectionScreen extends ConsumerStatefulWidget {
  const EmployerTypeSelectionScreen({super.key});

  @override
  ConsumerState<EmployerTypeSelectionScreen> createState() =>
      _EmployerTypeSelectionScreenState();
}

class _EmployerTypeSelectionScreenState
    extends ConsumerState<EmployerTypeSelectionScreen> {
  EmployerType? _selected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return IthakiScreenLayout(
      appBar: IthakiAppBar(
        actionLabel: l.loginAction,
        onActionPressed: () => context.go(Routes.loginPhone),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IthakiBackLink(onTap: () => context.pop()),
          const SizedBox(height: 16),
          Text(l.welcomeHeading, style: IthakiTheme.headingLarge),
          const SizedBox(height: 20),
          Text(l.employerTypeTitle, style: IthakiTheme.sectionTitle),
          const SizedBox(height: 8),
          Text(l.employerTypeDescription, style: IthakiTheme.bodyRegular),
          const SizedBox(height: 24),
          IthakiOptionCard(
            label: l.employerCompanyLabel,
            subtitle: l.employerCompanySubtitle,
            isSelected: _selected == EmployerType.employerCompany,
            onTap: () =>
                setState(() => _selected = EmployerType.employerCompany),
          ),
          const SizedBox(height: 12),
          IthakiOptionCard(
            label: l.employerNgoLabel,
            subtitle: l.employerNgoSubtitle,
            isSelected: _selected == EmployerType.ngo,
            onTap: () => setState(() => _selected = EmployerType.ngo),
          ),
          const SizedBox(height: 40),
          IthakiButton(
            l.continueButton,
            isEnabled: _selected != null,
            onPressed: _selected != null
                ? () {
                    ref
                        .read(registrationProvider.notifier)
                        .setEmployerType(_selected!);
                    ref
                        .read(employerSetupProvider.notifier)
                        .setType(_selected!);
                    context.push(Routes.registerEmployer);
                  }
                : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

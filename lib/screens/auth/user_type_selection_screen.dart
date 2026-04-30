import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/registration_provider.dart';
import '../../routes.dart';

enum _UserType { jobSeeker, employer }

class UserTypeSelectionScreen extends ConsumerStatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  ConsumerState<UserTypeSelectionScreen> createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState
    extends ConsumerState<UserTypeSelectionScreen> {
  _UserType? _selected;

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
          Text(l.welcomeHeading, style: IthakiTheme.headingLarge),
          const SizedBox(height: 20),
          Text(l.userTypeTitle, style: IthakiTheme.sectionTitle),
          const SizedBox(height: 8),
          Text(l.userTypeDescription, style: IthakiTheme.bodyRegular),
          const SizedBox(height: 24),
          IthakiOptionCard(
            label: l.userTypeJobSeekerLabel,
            subtitle: l.userTypeJobSeekerSubtitle,
            isSelected: _selected == _UserType.jobSeeker,
            onTap: () => setState(() => _selected = _UserType.jobSeeker),
          ),
          const SizedBox(height: 12),
          IthakiOptionCard(
            label: l.userTypeEmployerLabel,
            subtitle: l.userTypeEmployerSubtitle,
            isSelected: _selected == _UserType.employer,
            onTap: () => setState(() => _selected = _UserType.employer),
          ),
          const SizedBox(height: 40),
          IthakiButton(
            l.continueButton,
            isEnabled: _selected != null,
            onPressed: _selected != null
                ? () {
                    final isEmployer = _selected == _UserType.employer;
                    ref
                        .read(registrationProvider.notifier)
                        .setIsEmployer(isEmployer);
                    if (isEmployer) {
                      context.push(Routes.employerTypeSelection);
                    } else {
                      context.push(Routes.techComfort);
                    }
                  }
                : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

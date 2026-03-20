import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/registration_provider.dart';

enum _TechLevel { experienced, newToThis }

class TechComfortScreen extends ConsumerStatefulWidget {
  const TechComfortScreen({super.key});

  @override
  ConsumerState<TechComfortScreen> createState() => _TechComfortScreenState();
}

class _TechComfortScreenState extends ConsumerState<TechComfortScreen> {
  _TechLevel? _selected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return IthakiScreenLayout(
      appBar: IthakiAppBar(actionLabel: l.loginAction, onActionPressed: () => context.go('/login-phone')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.welcomeHeading, style: IthakiTheme.headingLarge),
          const SizedBox(height: 20),
          Text(l.techComfortTitle, style: IthakiTheme.sectionTitle),
          const SizedBox(height: 8),
          Text(
            l.techComfortDescription,
            style: IthakiTheme.bodyRegular,
          ),
          const SizedBox(height: 24),
          IthakiOptionCard(
            label: l.techExperiencedLabel,
            subtitle: l.techExperiencedSubtitle,
            isSelected: _selected == _TechLevel.experienced,
            onTap: () => setState(() => _selected = _TechLevel.experienced),
          ),
          const SizedBox(height: 12),
          IthakiOptionCard(
            label: l.techNewLabel,
            subtitle: l.techNewSubtitle,
            isSelected: _selected == _TechLevel.newToThis,
            onTap: () => setState(() => _selected = _TechLevel.newToThis),
          ),
          const SizedBox(height: 40),
          IthakiButton(
            l.continueButton,
            isEnabled: _selected != null,
            onPressed: _selected != null
                ? () {
                    ref.read(registrationProvider.notifier).setTechLevel(_selected!.name);
                    context.push('/register');
                  }
                : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

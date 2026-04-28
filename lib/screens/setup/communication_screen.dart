import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/setup_provider.dart';

class CommunicationScreen extends ConsumerStatefulWidget {
  const CommunicationScreen({super.key});

  @override
  ConsumerState<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends ConsumerState<CommunicationScreen> {
  final Set<String> _selected = {};
  bool _receiveTips = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return IthakiScreenLayout(
      appBar: const IthakiAppBar(showMenuAndAvatar: true),
      horizontalPadding: 0,
      verticalPadding: 8,
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IthakiStepTabs(
                steps: [l.stepLocation, l.stepJobInterests, l.stepPreferences, l.stepValues, l.stepCommunication],
                currentIndex: 4,
                completedUpTo: 3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.communicationHeading, style: IthakiTheme.headingLarge),
                    const SizedBox(height: 8),
                    Text(
                      l.communicationDescription,
                      style: IthakiTheme.bodyRegular,
                    ),
                    const SizedBox(height: 24),
                    IthakiOptionCard(
                      icon: 'whatsapp',
                      label: l.whatsapp,
                      isSelected: _selected.contains('whatsapp'),
                      onTap: () => setState(() => _selected.contains('whatsapp') ? _selected.remove('whatsapp') : _selected.add('whatsapp')),
                    ),
                    const SizedBox(height: 12),
                    IthakiOptionCard(
                      icon: 'message',
                      label: l.sms,
                      isSelected: _selected.contains('sms'),
                      onTap: () => setState(() => _selected.contains('sms') ? _selected.remove('sms') : _selected.add('sms')),
                    ),
                    const SizedBox(height: 12),
                    IthakiOptionCard(
                      icon: 'envelope',
                      label: l.email,
                      isSelected: _selected.contains('email'),
                      onTap: () => setState(() => _selected.contains('email') ? _selected.remove('email') : _selected.add('email')),
                    ),
                    const SizedBox(height: 20),
                    IthakiCheckbox(
                      value: _receiveTips,
                      onChanged: (val) => setState(() => _receiveTips = val),
                      child: Text(
                        l.receiveTips,
                        style: const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 40),
                    IthakiButton(
                      l.finishSetup,
                      onPressed: _selected.isNotEmpty
                          ? () {
                              ref.read(setupProvider.notifier).setCommunication(Set.of(_selected), _receiveTips);
                              context.go(Routes.fillProfile);
                            }
                          : null,
                    ),
                    const SizedBox(height: 12),
                    IthakiButton(
                      l.backButton,
                      variant: IthakiButtonVariant.outline,
                      onPressed: () => context.pop(),
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

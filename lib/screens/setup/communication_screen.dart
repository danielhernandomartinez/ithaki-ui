import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

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
                currentIndex: 4,
                completedUpTo: 3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Communication', style: IthakiTheme.headingLarge),
                    const SizedBox(height: 8),
                    const Text(
                      'Choose a channel to get notifications about new relevant job openings and responses to submitted applications. You can select multiple options and change them anytime.',
                      style: IthakiTheme.bodyRegular,
                    ),
                    const SizedBox(height: 24),
                    IthakiOptionCard(
                      icon: 'whatsapp',
                      label: 'WhatsApp',
                      isSelected: _selected.contains('whatsapp'),
                      onTap: () => setState(() => _selected.contains('whatsapp') ? _selected.remove('whatsapp') : _selected.add('whatsapp')),
                    ),
                    const SizedBox(height: 12),
                    IthakiOptionCard(
                      icon: 'message',
                      label: 'SMS',
                      isSelected: _selected.contains('sms'),
                      onTap: () => setState(() => _selected.contains('sms') ? _selected.remove('sms') : _selected.add('sms')),
                    ),
                    const SizedBox(height: 12),
                    IthakiOptionCard(
                      icon: 'envelope',
                      label: 'Email',
                      isSelected: _selected.contains('email'),
                      onTap: () => setState(() => _selected.contains('email') ? _selected.remove('email') : _selected.add('email')),
                    ),
                    const SizedBox(height: 20),
                    IthakiCheckbox(
                      value: _receiveTips,
                      onChanged: (val) => setState(() => _receiveTips = val),
                      child: const Text(
                        'Receive tips on job opportunities, information about courses, and upcoming events.',
                        style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 40),
                    IthakiButton(
                      'Finish Setup',
                      onPressed: _selected.isNotEmpty
                          ? () {
                              ref.read(setupProvider.notifier).setCommunication(Set.of(_selected), _receiveTips);
                              context.go('/home');
                            }
                          : null,
                    ),
                    const SizedBox(height: 12),
                    IthakiButton(
                      'Back',
                      variant: IthakiButtonVariant.outline,
                      onPressed: () => context.pop(),
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

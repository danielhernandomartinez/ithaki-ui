import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

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
    return IthakiScreenLayout(
      appBar: IthakiAppBar(actionLabel: 'Login', onActionPressed: () => context.go('/login')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome to Ithaki!\nLet\'s create an Account!', style: IthakiTheme.headingLarge),
          const SizedBox(height: 20),
          const Text('How comfortable are you with technology?', style: IthakiTheme.sectionTitle),
          const SizedBox(height: 8),
          const Text(
            'We\'ll use your answer to make the platform feel more comfortable for you.',
            style: IthakiTheme.bodyRegular,
          ),
          const SizedBox(height: 24),
          IthakiOptionCard(
            label: 'I\'m Experienced',
            subtitle: 'I feel comfortable using digital tools and enjoy exploring new technologies',
            isSelected: _selected == _TechLevel.experienced,
            onTap: () => setState(() => _selected = _TechLevel.experienced),
          ),
          const SizedBox(height: 12),
          IthakiOptionCard(
            label: 'I\'m still new to this',
            subtitle: 'I\'m not into complex tools - I prefer when technology just works smoothly',
            isSelected: _selected == _TechLevel.newToThis,
            onTap: () => setState(() => _selected = _TechLevel.newToThis),
          ),
          const Spacer(),
          IthakiButton(
            'Continue',
            isEnabled: _selected != null,
            onPressed: _selected != null
                ? () {
                    ref.read(registrationProvider.notifier).setTechLevel(_selected!.name);
                    context.go('/register');
                  }
                : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

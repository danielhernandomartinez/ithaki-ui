import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

enum _TechLevel { experienced, newToThis }

class TechComfortScreen extends StatefulWidget {
  const TechComfortScreen({super.key});

  @override
  State<TechComfortScreen> createState() => _TechComfortScreenState();
}

class _TechComfortScreenState extends State<TechComfortScreen> {
  _TechLevel? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IthakiAppBar(showLogin: true, onLoginPressed: () => context.go('/login')),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Ithaki!\nLet\'s create an Account!',
              style: IthakiTheme.headingLarge,
            ),
            const SizedBox(height: 20),
            const Text(
              'How comfortable are you with technology?',
              style: IthakiTheme.sectionTitle,
            ),
            const SizedBox(height: 8),
            const Text(
              'We\'ll use your answer to make the platform feel more comfortable for you.',
              style: IthakiTheme.bodyRegular,
            ),
            const SizedBox(height: 24),
            _OptionCard(
              title: 'I\'m Experienced',
              subtitle: 'I feel comfortable using digital tools and enjoy exploring new technologies',
              selected: _selected == _TechLevel.experienced,
              onTap: () => setState(() => _selected = _TechLevel.experienced),
            ),
            const SizedBox(height: 12),
            _OptionCard(
              title: 'I\'m still new to this',
              subtitle: 'I\'m not into complex tools - I prefer when technology just works smoothly',
              selected: _selected == _TechLevel.newToThis,
              onTap: () => setState(() => _selected = _TechLevel.newToThis),
            ),
            const Spacer(),
            IthakiButton(
              'Continue',
              isEnabled: _selected != null,
              onPressed: _selected != null ? () => context.go('/register') : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? IthakiTheme.primaryPurple.withValues(alpha: 0.07)
              : IthakiTheme.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? IthakiTheme.primaryPurple : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: selected ? IthakiTheme.primaryPurple : IthakiTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: IthakiTheme.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

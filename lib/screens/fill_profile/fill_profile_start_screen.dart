import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/fill_profile_provider.dart';
import '../../routes.dart';

class FillProfileStartScreen extends ConsumerWidget {
  const FillProfileStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottom = MediaQuery.viewPaddingOf(context).bottom;
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: IthakiTheme.backgroundWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Ithaki',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: IthakiTheme.primaryPurple,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Fill Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Complete your profile to get better job matches and stand out to employers. It only takes a few minutes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: IthakiTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              IthakiButton(
                'Start',
                onPressed: () => context.go(Routes.fillProfileSelect),
              ),
              const SizedBox(height: 12),
              IthakiButton(
                'Skip for now',
                variant: IthakiButtonVariant.outline,
                onPressed: () async {
                  await ref.read(fillProfileDoneProvider.notifier).markDone();
                  if (context.mounted) context.go(Routes.home);
                },
              ),
              SizedBox(height: bottom + 16),
            ],
          ),
        ),
      ),
    );
  }
}

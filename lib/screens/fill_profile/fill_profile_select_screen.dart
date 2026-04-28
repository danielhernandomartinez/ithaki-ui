import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../routes.dart';

class FillProfileSelectScreen extends StatelessWidget {
  const FillProfileSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        showBackButton: true,
        onMenuPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.viewPaddingOf(context).bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How would you like\nto fill your profile?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose the method that works best for you.',
              style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
            ),
            const SizedBox(height: 32),
            _MethodCard(
              icon: 'upload-cloud',
              title: 'Upload CV',
              description:
                  'Upload your existing CV and we\'ll automatically fill in your profile details.',
              onTap: () => context.go(Routes.fillProfileUpload),
            ),
            const SizedBox(height: 16),
            _MethodCard(
              icon: 'edit-pencil',
              title: 'Fill manually',
              description:
                  'Fill in your profile step by step. Takes about 5–10 minutes.',
              onTap: () => context.go(Routes.fillProfileWizard),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _MethodCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: IthakiTheme.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: IthakiTheme.accentPurpleLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: IthakiIcon(icon, size: 22, color: IthakiTheme.primaryPurple),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: IthakiTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const IthakiIcon('arrow-down', size: 16, color: IthakiTheme.softGraphite),
          ],
        ),
      ),
    );
  }
}

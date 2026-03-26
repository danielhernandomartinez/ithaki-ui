import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/profile_provider.dart';
import '../../../routes.dart';
import '../../../utils/language_utils.dart';

class _CompRow {
  final String label;
  final String value;
  const _CompRow(this.label, this.value);
}

class ProfileSkillsTab extends StatelessWidget {
  final ProfileState profile;
  const ProfileSkillsTab({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _skillsCard(context),
        const SizedBox(height: 8),
        _competenciesCard(context),
        const SizedBox(height: 8),
        _languagesCard(context),
      ],
    );
  }

  Widget _skillsCard(BuildContext context) {
    final hasSkills =
        profile.hardSkills.isNotEmpty || profile.softSkills.isNotEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Skills',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary)),
        const SizedBox(height: 8),
        if (!hasSkills) ...[
          const Text(
            'Add your technical and soft skills to help employers find and evaluate you.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          _outlineButton(const IthakiIcon('plus', size: 16),
              'Add Skills', () => context.push(Routes.profileSkills)),
        ] else ...[
          if (profile.hardSkills.isNotEmpty) ...[
            const Text('Hard Skills',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: profile.hardSkills.map(_skillBadge).toList(),
            ),
            const SizedBox(height: 16),
          ],
          if (profile.softSkills.isNotEmpty) ...[
            const Text('Soft Skills',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: profile.softSkills.map(_skillBadge).toList(),
            ),
            const SizedBox(height: 16),
          ],
          _outlineButton(const IthakiIcon('edit-pencil', size: 16),
              'Edit Skills', () => context.push(Routes.profileSkills)),
        ],
      ]),
    );
  }

  Widget _competenciesCard(BuildContext context) {
    final comp = profile.competencies;
    final rows = <_CompRow>[];
    if (profile.relocationReadiness.isNotEmpty) {
      rows.add(_CompRow('Willing to relocate', profile.relocationReadiness));
    }
    if ((comp['workPermit'] ?? '').isNotEmpty) {
      rows.add(_CompRow('Work Permit', comp['workPermit']!));
    }
    if ((comp['computerSkills'] ?? '').isNotEmpty) {
      rows.add(_CompRow('Computer Skills', comp['computerSkills']!));
    }
    if ((comp['drivingLicense'] ?? '').isNotEmpty) {
      final cat = comp['licenseCategory'] ?? '';
      final value = comp['drivingLicense'] == 'Yes' && cat.isNotEmpty
          ? 'Category $cat'
          : comp['drivingLicense']!;
      rows.add(_CompRow('Driving Licence', value));
    }
    final hasData = rows.isNotEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Competencies',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary)),
        const SizedBox(height: 8),
        if (!hasData) ...[
          const Text(
            'Select the skills that best represent your qualifications and professional expertise.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          _outlineButton(const IthakiIcon('plus', size: 16),
              'Add Competencies', () => context.push(Routes.profileCompetencies)),
        ] else ...[
          ...rows.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r.label,
                        style: const TextStyle(
                            fontSize: 14, color: IthakiTheme.textSecondary)),
                    Text(r.value,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: IthakiTheme.textPrimary)),
                  ],
                ),
              )),
          _outlineButton(const IthakiIcon('edit-pencil', size: 16),
              'Edit Competencies', () => context.push(Routes.profileCompetencies)),
        ],
      ]),
    );
  }

  Widget _languagesCard(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Languages',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 12),
          ...profile.languages.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      IthakiFlag(langCode(l.language), width: 20, height: 20),
                      const SizedBox(width: 8),
                      Text(l.language,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: IthakiTheme.textSecondary)),
                    ]),
                    Text(l.proficiency,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: IthakiTheme.textPrimary)),
                  ],
                ),
              )),
          _outlineButton(
            profile.languages.isEmpty
                ? const IthakiIcon('plus', size: 16)
                : const IthakiIcon('edit-pencil', size: 16),
            profile.languages.isEmpty ? 'Add Languages' : 'Edit Languages',
            () => context.push(Routes.profileLanguages),
          ),
        ]),
      );

  Widget _skillBadge(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 16, color: IthakiTheme.textPrimary)),
      );

  Widget _outlineButton(Widget icon, String label, VoidCallback onPressed) =>
      OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(label),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: IthakiTheme.softGraphite),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          foregroundColor: IthakiTheme.textPrimary,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
}

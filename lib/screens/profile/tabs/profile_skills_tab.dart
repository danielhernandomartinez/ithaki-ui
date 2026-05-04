import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/profile_provider.dart';
import '../../../routes.dart';

class _CompRow {
  final String label;
  final String value;
  const _CompRow(this.label, this.value);
}

class ProfileSkillsTab extends ConsumerWidget {
  const ProfileSkillsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills =
        ref.watch(profileSkillsProvider).value ?? const ProfileSkills();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _skillsCard(context, skills),
        const SizedBox(height: 8),
        _competenciesCard(context, skills),
        const SizedBox(height: 8),
        _languagesCard(context, skills),
      ],
    );
  }

  Widget _skillsCard(BuildContext context, ProfileSkills skills) {
    final hasSkills =
        skills.hardSkills.isNotEmpty || skills.softSkills.isNotEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
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
          _outlineButton(const IthakiIcon('plus', size: 16), 'Add Skills',
              () => context.push(Routes.profileSkills)),
        ] else ...[
          if (skills.hardSkills.isNotEmpty) ...[
            const Text('Hard Skills',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: skills.hardSkills.map(_skillBadge).toList(),
            ),
            const SizedBox(height: 16),
          ],
          if (skills.softSkills.isNotEmpty) ...[
            const Text('Soft Skills',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: skills.softSkills.map(_skillBadge).toList(),
            ),
            const SizedBox(height: 16),
          ],
          _outlineButton(const IthakiIcon('edit-pencil', size: 16),
              'Edit Skills', () => context.push(Routes.profileSkills)),
        ],
      ]),
    );
  }

  Widget _competenciesCard(BuildContext context, ProfileSkills skills) {
    final comp = skills.competencies;
    final rows = _competencyRows(comp);
    final hasData = rows.isNotEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
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
          _outlineButton(const IthakiIcon('plus', size: 16), 'Add Competencies',
              () => context.push(Routes.profileCompetencies)),
        ] else ...[
          ...rows.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(r.label,
                          style: const TextStyle(
                              fontSize: 14, color: IthakiTheme.textSecondary)),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        r.value,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: IthakiTheme.textPrimary),
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(
            width: double.infinity,
            child: _outlineButton(
                const IthakiIcon('edit-pencil', size: 16),
                'Edit Competencies',
                () => context.push(Routes.profileCompetencies)),
          ),
        ],
      ]),
    );
  }

  List<_CompRow> _competencyRows(Map<String, String> competencies) {
    const preferredOrder = [
      'computerSkills',
      'drivingLicense',
      'licenseCategory',
      'greekLicense',
    ];
    final rows = <_CompRow>[];
    final used = <String>{};

    for (final key in preferredOrder) {
      final value = competencies[key]?.trim();
      if (value == null || value.isEmpty) continue;
      rows.add(_CompRow(key, value));
      used.add(key);
    }

    for (final entry in competencies.entries) {
      final value = entry.value.trim();
      if (used.contains(entry.key) || value.isEmpty) continue;
      rows.add(_CompRow(entry.key, value));
    }

    return rows;
  }

  Widget _languagesCard(BuildContext context, ProfileSkills skills) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Languages',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 12),
          ...skills.languages.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      IthakiLanguageFlag(l.language, size: 20),
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
            skills.languages.isEmpty
                ? const IthakiIcon('plus', size: 16)
                : const IthakiIcon('edit-pencil', size: 16),
            skills.languages.isEmpty ? 'Add Languages' : 'Edit Languages',
            () => context.push(Routes.profileLanguages),
          ),
        ]),
      );

  Widget _skillBadge(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: IthakiTheme.softGray,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label,
            style:
                const TextStyle(fontSize: 16, color: IthakiTheme.textPrimary)),
      );

  Widget _outlineButton(Widget icon, String label, VoidCallback onPressed) =>
      OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(label),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: IthakiTheme.softGraphite),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          foregroundColor: IthakiTheme.textPrimary,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
}

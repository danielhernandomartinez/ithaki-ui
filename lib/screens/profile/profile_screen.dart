import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../models/profile_models.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/upload_files_sheet.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _tabIndex = 0;

  static const _tabs = [
    'Job Preferences',
    'About Me',
    'Skills',
    'Work Experience',
    'Education',
    'Files',
    'Values',
  ];

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final topOffset = MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        avatarInitials:
            '${profile.firstName.isNotEmpty ? profile.firstName[0] : '?'}${profile.lastName.isNotEmpty ? profile.lastName[0] : '?'}',
        onMenuPressed: () {},
        onAvatarPressed: () {},
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: topOffset + 16),
            _buildHeaderCard(profile),
            const SizedBox(height: 12),
            _buildTabBar(),
            const SizedBox(height: 12),
            _buildTabContent(profile),
            const SizedBox(height: 80),
            IthakiFooter(
              brandName: 'Ithaki',
              copyright: '© 2025 Ithaki. All rights reserved.',
            ),
          ]),
        ),
        _buildStickyBottomBar(profile),
      ]),
    );
  }

  // ─── Header Card ──────────────────────────────────────────────────

  Widget _buildHeaderCard(ProfileState profile) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: IthakiTheme.primaryPurple,
              child: Text(
                '${profile.firstName.isNotEmpty ? profile.firstName[0] : '?'}${profile.lastName.isNotEmpty ? profile.lastName[0] : '?'}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '${profile.firstName} ${profile.lastName}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: IthakiTheme.textPrimary),
              ),
              Text(
                profile.jobInterests.isNotEmpty
                    ? profile.jobInterests.first.title
                    : profile.jobType.isNotEmpty
                        ? profile.jobType
                        : 'Job Seeker',
                style: const TextStyle(
                    fontSize: 14, color: IthakiTheme.textSecondary),
              ),
            ]),
          ]),
          const SizedBox(height: 12),
          _contactRow(const IthakiIcon('envelope', size: 16), profile.email),
          const SizedBox(height: 4),
          _contactRow(const IthakiIcon('phone', size: 20), profile.phone),
          const SizedBox(height: 8),
          const Text(
            "Employers won't see your contact details until you apply for a job or accept an invitation.",
            style: TextStyle(fontSize: 12, color: IthakiTheme.textSecondary),
          ),
          const Divider(height: 24),
          Row(children: [
            Expanded(child: _infoCell('Gender', profile.gender)),
            Expanded(child: _infoCell('Age', _calcAge(profile.dateOfBirth))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _infoCell('Citizenship', profile.citizenship)),
            Expanded(child: _infoCell('Location', profile.residence)),
          ]),
          const SizedBox(height: 12),
          _iconOutlineButton(
              const IthakiIcon('edit-pencil', size: 16),
              'Edit Profile Basics',
              () => context.push('/profile/basics')),
        ]),
      );

  // ─── Tab Bar ──────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE9DEFF),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _tabs.asMap().entries.map((e) {
              final selected = e.key == _tabIndex;
              return Padding(
                padding: EdgeInsets.only(
                    left: e.key == 0 ? 0 : 6),
                child: GestureDetector(
                  onTap: () => setState(() => _tabIndex = e.key),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      e.value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected
                            ? IthakiTheme.textPrimary
                            : IthakiTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ─── Tab Content Dispatcher ───────────────────────────────────────

  Widget _buildTabContent(ProfileState profile) {
    switch (_tabIndex) {
      case 0:
        return _buildJobPreferencesTab(profile);
      case 1:
        return _buildAboutMeTab(profile);
      case 2:
        return _buildSkillsTab(profile);
      case 3:
        return _buildWorkExperienceTab(profile);
      case 4:
        return _buildEducationTab(profile);
      case 5:
        return _buildFilesTab(profile);
      case 6:
        return _buildValuesTab(profile);
      default:
        return const SizedBox.shrink();
    }
  }

  // ─── Tab: Job Preferences ─────────────────────────────────────────

  Widget _buildJobPreferencesTab(ProfileState profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'Job Preferences',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: IthakiTheme.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'This shows the job you are currently looking for. You can change this anytime.',
          style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 16),
        if (profile.jobInterests.isNotEmpty) ...[
          const Text(
            'Job Interests',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          ...profile.jobInterests.map(_jobInterestCard),
          const SizedBox(height: 8),
        ],
        const Text(
          'Preferences',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        _prefGrid(profile),
        const SizedBox(height: 12),
        _iconOutlineButton(
          const IthakiIcon('edit-pencil', size: 16),
          'Edit Jobs Preferences',
          () => context.push('/profile/job-preferences'),
        ),
      ]),
    );
  }

  Widget _jobInterestCard(JobInterest jobInterest) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7FC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: IthakiTheme.primaryPurple.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.rocket_launch_outlined,
                size: 18, color: IthakiTheme.primaryPurple),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(jobInterest.title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary)),
                  Text(jobInterest.category,
                      style: const TextStyle(
                          fontSize: 12, color: IthakiTheme.textSecondary)),
                ]),
          ),
        ]),
      );

  Widget _prefGrid(ProfileState profile) {
    final salary = profile.preferNotToSpecifySalary
        ? 'Not specified'
        : profile.expectedSalary != null
            ? '${profile.expectedSalary!.toStringAsFixed(0)} € / month'
            : '—';
    return Column(children: [
      Row(children: [
        Expanded(child: _prefCell(Icons.business_outlined, 'Workspace',
            profile.workplace.isNotEmpty ? profile.workplace : '—')),
        const SizedBox(width: 8),
        Expanded(child: _prefCell(Icons.access_time_outlined, 'Job Type',
            profile.jobType.isNotEmpty ? profile.jobType : '—')),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: _prefCell(Icons.bar_chart_outlined, 'Level',
            profile.positionLevel.isNotEmpty ? profile.positionLevel : '—')),
        const SizedBox(width: 8),
        Expanded(child: _prefCell(
            Icons.account_balance_wallet_outlined, 'Desired Salary', salary)),
      ]),
    ]);
  }

  Widget _prefCell(IconData icon, String label, String value) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7FC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 16, color: IthakiTheme.softGraphite),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11, color: IthakiTheme.textSecondary)),
                  const SizedBox(height: 2),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary)),
                ]),
          ),
        ]),
      );

  // ─── Tab: About Me ────────────────────────────────────────────────

  Widget _buildAboutMeTab(ProfileState profile) {
    if (profile.bio.isEmpty) {
      return _emptyCard(
        message: 'No about me information added yet.',
        button: _iconOutlineButton(const IthakiIcon('plus', size: 16),
            'Add About Me Information', () => context.push('/profile/about-me')),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(profile.bio,
            style: const TextStyle(
                fontSize: 14, color: IthakiTheme.textSecondary, height: 1.5)),
        if (profile.videoUrl != null) ...[
          const SizedBox(height: 16),
          const Text('Introduction Video',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_outline,
                    size: 48, color: IthakiTheme.softGraphite),
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        _iconOutlineButton(const IthakiIcon('edit-pencil', size: 16),
            'Edit About Me', () => context.push('/profile/about-me')),
      ]),
    );
  }

  // ─── Tab: Skills ──────────────────────────────────────────────────

  Widget _buildSkillsTab(ProfileState profile) {
    final isEmpty = profile.hardSkills.isEmpty &&
        profile.softSkills.isEmpty &&
        profile.languages.isEmpty &&
        profile.competencies.isEmpty;

    if (isEmpty) {
      return _emptyCard(
        message: 'No skills added yet.',
        button: _iconOutlineButton(const IthakiIcon('plus', size: 16),
            'Add Skills', () => context.push('/profile/skills')),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (profile.hardSkills.isNotEmpty) ...[
          const Text('Hard Skills',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.hardSkills.map(_chip).toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (profile.softSkills.isNotEmpty) ...[
          const Text('Soft Skills',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.softSkills.map(_chip).toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (profile.competencies.isNotEmpty) ...[
          const Text('Competencies',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 8),
          ...profile.competencies.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Text('${e.key}: ',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary)),
                  Text(e.value,
                      style: const TextStyle(
                          fontSize: 13, color: IthakiTheme.textSecondary)),
                ]),
              )),
          const SizedBox(height: 12),
        ],
        if (profile.languages.isNotEmpty) ...[
          const Text('Languages',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 8),
          ...profile.languages.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  const Icon(Icons.flag_outlined,
                      size: 16, color: IthakiTheme.softGraphite),
                  const SizedBox(width: 6),
                  Text(l.language,
                      style: const TextStyle(
                          fontSize: 13, color: IthakiTheme.textPrimary)),
                  const SizedBox(width: 8),
                  Text(l.proficiency,
                      style: const TextStyle(
                          fontSize: 12, color: IthakiTheme.textSecondary)),
                ]),
              )),
        ],
      ]),
    );
  }

  // ─── Tab: Work Experience ─────────────────────────────────────────

  Widget _buildWorkExperienceTab(ProfileState profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...profile.workExperiences.asMap().entries.map((entry) {
          final exp = entry.value;
          final endLabel =
              exp.currentlyWorkHere ? 'Present' : (exp.endDate ?? '');
          return Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(exp.jobTitle,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 2),
              Text(exp.companyName,
                  style: const TextStyle(
                      fontSize: 13, color: IthakiTheme.textSecondary)),
              const SizedBox(height: 2),
              Text('${exp.startDate} – $endLabel',
                  style: const TextStyle(
                      fontSize: 12, color: IthakiTheme.softGraphite)),
              const SizedBox(height: 12),
              _iconOutlineButton(const IthakiIcon('edit-pencil', size: 16),
                  'Edit', () => context.push('/profile/work-experience')),
            ]),
          );
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _iconOutlineButton(const IthakiIcon('plus', size: 16),
              'Add Work Experience', () => context.push('/profile/work-experience')),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  // ─── Tab: Education ───────────────────────────────────────────────

  Widget _buildEducationTab(ProfileState profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...profile.educations.asMap().entries.map((entry) {
          final edu = entry.value;
          final endLabel =
              edu.currentlyStudyHere ? 'Present' : (edu.endDate ?? '');
          return Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(edu.institutionName,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 2),
              Text('${edu.degreeType} – ${edu.fieldOfStudy}',
                  style: const TextStyle(
                      fontSize: 13, color: IthakiTheme.textSecondary)),
              const SizedBox(height: 2),
              Text('${edu.startDate} – $endLabel',
                  style: const TextStyle(
                      fontSize: 12, color: IthakiTheme.softGraphite)),
              const SizedBox(height: 12),
              _iconOutlineButton(const IthakiIcon('edit-pencil', size: 16),
                  'Edit', () => context.push('/profile/education')),
            ]),
          );
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _iconOutlineButton(const IthakiIcon('plus', size: 16),
              'Add Education', () => context.push('/profile/education')),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  // ─── Tab: Files ───────────────────────────────────────────────────

  Widget _buildFilesTab(ProfileState profile) {
    if (profile.files.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(children: [
          const Text(
            'No documents uploaded yet.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          _iconOutlineButton(
            const IthakiIcon('upload-cloud', size: 16),
            'Upload Documents',
            () => UploadFilesSheet.show(context, onContinue: (files) {
              for (final f in files) {
                ref.read(profileProvider.notifier).addFile(f);
              }
            }),
          ),
        ]),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ...profile.files.asMap().entries.map((entry) {
          final i = entry.key;
          final f = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Text('PDF',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: IthakiTheme.softGraphite)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f.name,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: IthakiTheme.textPrimary)),
                      Text(f.size,
                          style: const TextStyle(
                              fontSize: 12, color: IthakiTheme.textSecondary)),
                    ]),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Open',
                    style: TextStyle(color: IthakiTheme.primaryPurple)),
              ),
              TextButton(
                onPressed: () =>
                    ref.read(profileProvider.notifier).deleteFile(i),
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ]),
          );
        }),
        const SizedBox(height: 4),
        _iconOutlineButton(
          const IthakiIcon('upload-cloud', size: 16),
          'Upload Documents',
          () => UploadFilesSheet.show(context, onContinue: (files) {
            for (final f in files) {
              ref.read(profileProvider.notifier).addFile(f);
            }
          }),
        ),
      ]),
    );
  }

  // ─── Tab: Values ──────────────────────────────────────────────────

  Widget _buildValuesTab(ProfileState profile) {
    if (profile.values.isEmpty) {
      return _emptyCard(
        message: 'No values added yet.',
        button: _iconOutlineButton(const IthakiIcon('edit-pencil', size: 16),
            'Update Values', () => context.push('/setup/values')),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: profile.values.map(_chip).toList(),
        ),
        const SizedBox(height: 12),
        _iconOutlineButton(const IthakiIcon('edit-pencil', size: 16),
            'Update Values', () => context.push('/setup/values')),
      ]),
    );
  }

  // ─── Sticky Bottom Bar ────────────────────────────────────────────

  Widget _buildStickyBottomBar(ProfileState profile) {
    final isIncomplete = profile.jobInterests.isEmpty &&
        profile.workExperiences.isEmpty &&
        profile.educations.isEmpty;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
        child: isIncomplete
            ? Row(children: [
                Expanded(
                    child: IthakiButton('Fill Profile',
                        onPressed: () => context.push('/profile/basics'))),
                const SizedBox(width: 8),
                _moreButton(context),
              ])
            : Row(children: [
                Expanded(child: _iconOutlineButton(
                    const IthakiIcon('resume', size: 16), 'Open CV', () {})),
                const SizedBox(width: 8),
                Expanded(child: _iconOutlineButton(
                    const IthakiIcon('settings', size: 16), 'Account Settings',
                    () => context.push('/settings'))),
              ]),
      ),
    );
  }

  // ─── Small Helpers ────────────────────────────────────────────────

  Widget _emptyCard({required String message, required Widget button}) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(message,
              style: const TextStyle(
                  fontSize: 14, color: IthakiTheme.textSecondary)),
          const SizedBox(height: 12),
          button,
        ]),
      );

  Widget _chip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F2FE),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFDDD5F8)),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 13, color: IthakiTheme.primaryPurple)),
      );

  Widget _contactRow(Widget icon, String text) => Row(children: [
        icon,
        const SizedBox(width: 6),
        Text(text,
            style: const TextStyle(
                fontSize: 13, color: IthakiTheme.textSecondary)),
      ]);

  Widget _infoCell(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: IthakiTheme.textSecondary)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
        ],
      );

  Widget _iconOutlineButton(Widget icon, String label, VoidCallback onPressed) =>
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: icon,
          label: Text(label),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            foregroundColor: IthakiTheme.textPrimary,
          ),
        ),
      );


  Widget _moreButton(BuildContext ctx) => OutlinedButton(
        onPressed: () {
          showMenu(
            context: ctx,
            position: const RelativeRect.fromLTRB(100, 0, 16, 0),
            items: [
              const PopupMenuItem(value: 'cv', child: Text('Open CV')),
              const PopupMenuItem(
                  value: 'settings', child: Text('Account Settings')),
            ],
          ).then((v) {
            if (v == 'settings' && mounted) context.push('/settings');
          });
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(12),
        ),
        child: const Icon(Icons.more_horiz, color: IthakiTheme.textPrimary),
      );

  String _calcAge(String dob) {
    final parts = dob.split('-');
    if (parts.length < 3) return '';
    final year = int.tryParse(parts[2]);
    if (year == null) return '';
    final age = DateTime.now().year - year;
    return '$age';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/employer_dashboard_models.dart';

// ── Mock candidate model (local to this screen for now) ──────────────────────

enum CandidateStatus { newCandidate, viewed, shortlisted, declined }

enum MatchStrength { strong, good, weak }

class _Candidate {
  final String name;
  final String jobTitle;
  final String location;
  final MatchStrength match;
  final CandidateStatus status;
  final String initials;

  const _Candidate({
    required this.name,
    required this.jobTitle,
    required this.location,
    required this.match,
    required this.status,
    required this.initials,
  });
}

const _mockCandidates = [
  _Candidate(
    name: 'Nikos Papadakis',
    jobTitle: 'Sales Manager',
    location: 'Thessaloniki, Greece',
    match: MatchStrength.strong,
    status: CandidateStatus.newCandidate,
    initials: 'NP',
  ),
  _Candidate(
    name: 'Elena Koutrouki',
    jobTitle: 'Sales Manager',
    location: 'Athens, Greece',
    match: MatchStrength.strong,
    status: CandidateStatus.viewed,
    initials: 'EK',
  ),
  _Candidate(
    name: 'Omar Al-Hassan',
    jobTitle: 'Sales Manager',
    location: 'Volos, Greece',
    match: MatchStrength.strong,
    status: CandidateStatus.shortlisted,
    initials: 'OH',
  ),
  _Candidate(
    name: 'Layla Mansour',
    jobTitle: 'Sales Manager',
    location: 'Athens, Greece',
    match: MatchStrength.strong,
    status: CandidateStatus.declined,
    initials: 'LM',
  ),
  _Candidate(
    name: 'Oleksandr Kovalenko',
    jobTitle: 'Sales Manager',
    location: 'Athens, Greece',
    match: MatchStrength.strong,
    status: CandidateStatus.viewed,
    initials: 'OK',
  ),
  _Candidate(
    name: 'Iryna Demchuk',
    jobTitle: 'Sales Manager',
    location: 'Athens, Greece',
    match: MatchStrength.strong,
    status: CandidateStatus.shortlisted,
    initials: 'ID',
  ),
  _Candidate(
    name: 'Karim Abdel Rahman',
    jobTitle: 'Sales Manager',
    location: 'Athens, Greece',
    match: MatchStrength.strong,
    status: CandidateStatus.declined,
    initials: 'KA',
  ),
  _Candidate(
    name: 'Sofia Christou',
    jobTitle: 'Office Manager',
    location: 'Chalkida, Greece',
    match: MatchStrength.strong,
    status: CandidateStatus.declined,
    initials: 'SC',
  ),
];

// ── Screen ───────────────────────────────────────────────────────────────────

class EmployerJobDetailScreen extends ConsumerStatefulWidget {
  final JobPost jobPost;

  const EmployerJobDetailScreen({super.key, required this.jobPost});

  @override
  ConsumerState<EmployerJobDetailScreen> createState() =>
      _EmployerJobDetailScreenState();
}

class _EmployerJobDetailScreenState
    extends ConsumerState<EmployerJobDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _fullInfoExpanded = false;
  int _selectedTab = 0; // 0 = Candidates, 1 = Applications

  JobPost get job => widget.jobPost;

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        showBackButton: true,
        onMenuPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // ── Job info card ───────────────────────────────
            IthakiCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderRow(l10n),
                  const SizedBox(height: 12),
                  // Company logo + title
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: IthakiTheme.placeholderBg,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: IthakiIcon('team',
                              size: 22, color: IthakiTheme.softGraphite),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(job.title, style: IthakiTheme.headingLarge),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: IthakiTheme.borderLight, height: 1),
                  const SizedBox(height: 16),

                  // Detail grid
                  _DetailGrid(job: job, l10n: l10n),

                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _fullInfoExpanded = !_fullInfoExpanded),
                    child: Center(
                      child: Text(
                        _fullInfoExpanded
                            ? l10n.jobDetailHideFullInfo
                            : l10n.jobDetailOpenFullInfo,
                        style: IthakiTheme.bodySmall.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: IthakiTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  if (_fullInfoExpanded) ...[
                    const SizedBox(height: 16),
                    _FullInfoSection(),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Stats + Candidates card ──────────────────────
            IthakiCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _StatCell(
                        count: 160,
                        badge: '+9 new',
                        label: l10n.jobDetailViews,
                      ),
                      const SizedBox(width: 16),
                      _StatCell(
                        count: 7,
                        badge: '+1',
                        label: l10n.jobDetailCandidates,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tabs
                  _JobDetailTabBar(
                    selected: _selectedTab,
                    candidatesLabel: l10n.jobDetailCandidates,
                    applicationsLabel: l10n.jobDetailApplications,
                    candidatesCount: _mockCandidates.length,
                    onSelect: (i) => setState(() => _selectedTab = i),
                  ),
                  const SizedBox(height: 16),

                  // Candidates header
                  Text(
                    l10n.jobDetailYouHaveCandidates(_mockCandidates.length),
                    style: IthakiTheme.bodySmallBold,
                  ),
                  const SizedBox(height: 12),

                  // Candidate list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _mockCandidates.length,
                    separatorBuilder: (_, __) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child:
                          Divider(color: IthakiTheme.borderLight, height: 1),
                    ),
                    itemBuilder: (_, i) =>
                        _CandidateTile(candidate: _mockCandidates[i], l10n: l10n),
                  ),
                ],
              ),
            ),

            SizedBox(height: MediaQuery.paddingOf(context).bottom + 90),
          ],
        ),
      ),

      // ── Bottom action bar ─────────────────────────────────
      bottomNavigationBar: _BottomBar(job: job, l10n: l10n),
    );
  }

  Widget _buildHeaderRow(AppLocalizations l10n) {
    final postedStr = _formatDate(job.createdAt);
    return Row(
      children: [
        Text(
          l10n.jobDetailPosted(postedStr),
          style: IthakiTheme.captionRegular,
        ),
        const Spacer(),
        if (job.status == JobPostStatus.boosted && job.boostedUntil != null)
          _StatusPill(
            label: l10n.jobDetailBoostedTill(job.boostedUntil!
                .replaceFirst('till ', '')),
            bg: IthakiTheme.chipActive,
            textColor: IthakiTheme.primaryPurple,
          )
        else if (job.status == JobPostStatus.expired)
          _StatusPill(
            label: l10n.jobStatusExpired,
            bg: IthakiTheme.softGray,
            textColor: IthakiTheme.softGraphite,
          )
        else if (job.status == JobPostStatus.published)
          _StatusPill(
            label: l10n.jobStatusPublished,
            bg: IthakiTheme.matchBarBg,
            textColor: IthakiTheme.matchGradientHighStart,
          ),
      ],
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;

  const _StatusPill({
    required this.label,
    required this.bg,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class _DetailGrid extends StatelessWidget {
  final JobPost job;
  final AppLocalizations l10n;

  const _DetailGrid({required this.job, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final items = [
      (l10n.jobDetailLocation, 'location', 'Thessaloniki'),
      (l10n.jobDetailJobType, 'clock', 'Full-Time'),
      (l10n.jobDetailIndustry, 'jobs', job.category),
      (l10n.jobDetailSalaryRange, 'envelope', job.salary),
      (l10n.jobDetailWorkplace, 'home', 'Office'),
      (l10n.jobDetailExperienceLevel, 'assessment', 'Entry'),
      (l10n.jobDetailLanguage, 'flag', 'English, Greek'),
    ];

    return Wrap(
      spacing: 0,
      runSpacing: 12,
      children: [
        for (int i = 0; i < items.length; i++)
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 2 - 40,
            child: _DetailCell(
              label: items[i].$1,
              icon: items[i].$2,
              value: items[i].$3,
            ),
          ),
      ],
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String label;
  final String icon;
  final String value;

  const _DetailCell({
    required this.label,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: IthakiTheme.captionRegular),
        const SizedBox(height: 4),
        Row(
          children: [
            IthakiIcon(icon, size: 16, color: IthakiTheme.softGraphite),
            const SizedBox(width: 4),
            Flexible(
              child: Text(value, style: IthakiTheme.bodySmallSemiBold),
            ),
          ],
        ),
      ],
    );
  }
}

class _FullInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: IthakiTheme.borderLight, height: 1),
        const SizedBox(height: 12),
        Text('Skills Required',
            style: IthakiTheme.bodySmallBold),
        const SizedBox(height: 6),
        Text(
          'Communication skill  Negotiation skill\nClient Relationship Management\nPresentation Skills & Closing Skill\nProblem-Solving  Self Management',
          style: IthakiTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        Text('About the role', style: IthakiTheme.bodySmallBold),
        const SizedBox(height: 6),
        Text(
          'We are looking for a performance-based and results-driven Sales Manager to join our logistics team to manage our transportation and logistics products, grow our client base, and drive closed deals with new customers across Europe.',
          style: IthakiTheme.bodySecondary,
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  final int count;
  final String? badge;
  final String label;

  const _StatCell({required this.count, this.badge, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('$count', style: IthakiTheme.headingLarge),
        if (badge != null) ...[
          const SizedBox(width: 6),
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: IthakiTheme.badgeLime,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ],
        const SizedBox(width: 6),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(label, style: IthakiTheme.captionRegular),
        ),
      ],
    );
  }
}

class _JobDetailTabBar extends StatelessWidget {
  final int selected;
  final String candidatesLabel;
  final String applicationsLabel;
  final int candidatesCount;
  final ValueChanged<int> onSelect;

  const _JobDetailTabBar({
    required this.selected,
    required this.candidatesLabel,
    required this.applicationsLabel,
    required this.candidatesCount,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _Tab(
            label: '$candidatesLabel ($candidatesCount)',
            isSelected: selected == 0,
            onTap: () => onSelect(0),
          ),
          _Tab(
            label: applicationsLabel,
            isSelected: selected == 1,
            onTap: () => onSelect(1),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? IthakiTheme.backgroundWhite
                : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Center(
            child: Text(
              label,
              style: IthakiTheme.bodySmallSemiBold.copyWith(
                color: isSelected
                    ? IthakiTheme.textPrimary
                    : IthakiTheme.softGraphite,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

class _CandidateTile extends StatelessWidget {
  final _Candidate candidate;
  final AppLocalizations l10n;

  const _CandidateTile({required this.candidate, required this.l10n});

  ({Color bg, Color text, String label}) _matchStyle() => switch (candidate.match) {
        MatchStrength.strong => (
            bg: IthakiTheme.matchBarBg,
            text: IthakiTheme.matchGradientHighStart,
            label: l10n.matchStrengthStrong,
          ),
        MatchStrength.good => (
            bg: IthakiTheme.matchBgGood,
            text: IthakiTheme.matchGradientGoodStart,
            label: l10n.matchStrengthGood,
          ),
        MatchStrength.weak => (
            bg: IthakiTheme.matchBgWeak,
            text: IthakiTheme.matchGradientWeakStart,
            label: l10n.matchStrengthWeak,
          ),
      };

  ({Color bg, Color text, String label}) _statusStyle() =>
      switch (candidate.status) {
        CandidateStatus.newCandidate => (
            bg: IthakiTheme.badgeLime,
            text: IthakiTheme.textPrimary,
            label: l10n.candidateStatusNew,
          ),
        CandidateStatus.viewed => (
            bg: IthakiTheme.softGray,
            text: IthakiTheme.softGraphite,
            label: l10n.candidateStatusViewed,
          ),
        CandidateStatus.shortlisted => (
            bg: IthakiTheme.chipActive,
            text: IthakiTheme.primaryPurple,
            label: l10n.candidateStatusShortlisted,
          ),
        CandidateStatus.declined => (
            bg: IthakiTheme.softGray,
            text: IthakiTheme.softGraphite,
            label: l10n.candidateStatusDeclined,
          ),
      };

  @override
  Widget build(BuildContext context) {
    final match = _matchStyle();
    final status = _statusStyle();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: IthakiTheme.placeholderBg,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              candidate.initials,
              style: IthakiTheme.bodySmallBold.copyWith(
                color: IthakiTheme.softGraphite,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Name + info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(candidate.name, style: IthakiTheme.bodySmallBold),
              Text(candidate.jobTitle, style: IthakiTheme.captionRegular),
              Text(candidate.location, style: IthakiTheme.captionRegular),
              const SizedBox(height: 6),
              Row(
                children: [
                  // Match badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: match.bg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      match.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: match.text,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Status chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: status.bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: status.text,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  final JobPost job;
  final AppLocalizations l10n;

  const _BottomBar({required this.job, required this.l10n});

  bool get _isExpired => job.status == JobPostStatus.expired;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IthakiTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IthakiIcon(
                        _isExpired ? 'rocket' : 'x-close',
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isExpired
                            ? l10n.jobActionPublishAgain
                            : l10n.jobDetailCloseJob,
                        style: IthakiTheme.buttonLabel,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _MoreButton(l10n: l10n),
          ],
        ),
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  final AppLocalizations l10n;

  const _MoreButton({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (_) {},
      offset: const Offset(0, -120),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const IthakiIcon('edit-pencil',
                  size: 18, color: IthakiTheme.textPrimary),
              const SizedBox(width: 10),
              Text(l10n.jobDetailEditJobPost),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'pause',
          child: Row(
            children: [
              const IthakiIcon('clock',
                  size: 18, color: IthakiTheme.textPrimary),
              const SizedBox(width: 10),
              Text(l10n.jobDetailPausePublication),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const IthakiIcon('delete',
                  size: 18, color: IthakiTheme.textPrimary),
              const SizedBox(width: 10),
              Text(l10n.jobDetailDelete),
            ],
          ),
        ),
      ],
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: IthakiTheme.softGray,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: IthakiIcon('settings',
              size: 20, color: IthakiTheme.softGraphite),
        ),
      ),
    );
  }
}

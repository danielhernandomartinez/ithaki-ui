import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/employer_dashboard_models.dart';

enum _InviteStatus { pending, sent }

class _AiCandidate {
  final String name;
  final String jobTitle;
  final String location;
  final String salary;
  final int matchPercent;
  final String initials;
  _InviteStatus status = _InviteStatus.pending;

  _AiCandidate({
    required this.name,
    required this.jobTitle,
    required this.location,
    required this.salary,
    required this.matchPercent,
    required this.initials,
  });
}

class EmployerAiMatcherScreen extends ConsumerStatefulWidget {
  final JobPost jobPost;

  const EmployerAiMatcherScreen({super.key, required this.jobPost});

  @override
  ConsumerState<EmployerAiMatcherScreen> createState() =>
      _EmployerAiMatcherScreenState();
}

class _EmployerAiMatcherScreenState
    extends ConsumerState<EmployerAiMatcherScreen> {
  final List<_AiCandidate> _candidates = [
    _AiCandidate(
      name: 'Karim Abdel Rahman',
      jobTitle: 'Sales Manager',
      location: 'Chalkidiki, Greece',
      salary: '1,300 € /month',
      matchPercent: 100,
      initials: 'KA',
    ),
    _AiCandidate(
      name: 'Nikos Papadakis',
      jobTitle: 'Sales Manager',
      location: 'Chalkidiki, Greece',
      salary: '1,300 € /month',
      matchPercent: 100,
      initials: 'NP',
    ),
  ];

  bool get _allSent =>
      _candidates.every((c) => c.status == _InviteStatus.sent);

  void _sendInvitation(int index) {
    setState(() => _candidates[index].status = _InviteStatus.sent);
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _FiltersSheet(jobPost: widget.jobPost),
    );
  }

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

            // ── Header card ────────────────────────────────────
            IthakiCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.aiMatcherTitle, style: IthakiTheme.headingLarge),
                  const SizedBox(height: 8),
                  Text(l10n.aiMatcherSubtitle,
                      style: IthakiTheme.bodySecondary),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Job selector chip
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: IthakiTheme.primaryPurple,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const IthakiIcon('ai',
                                  size: 16, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                widget.jobPost.title,
                                style: IthakiTheme.buttonLabel.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Filters button
                      GestureDetector(
                        onTap: _showFilters,
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: IthakiTheme.borderLight),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const IthakiIcon('settings',
                                  size: 16, color: IthakiTheme.textPrimary),
                              const SizedBox(width: 6),
                              Text(l10n.aiMatcherFilters,
                                  style: IthakiTheme.bodySmallSemiBold),
                              const SizedBox(width: 4),
                              const IthakiIcon('arrow-down',
                                  size: 14,
                                  color: IthakiTheme.softGraphite),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Results card ───────────────────────────────────
            IthakiCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.aiMatcherCandidatesFound(_candidates.length),
                        style: IthakiTheme.bodySmallBold,
                      ),
                      const Spacer(),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: IthakiTheme.softGray,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: IthakiIcon('settings',
                              size: 18, color: IthakiTheme.softGraphite),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (_allSent)
                    Text(l10n.aiMatcherAllSent,
                        style: IthakiTheme.bodySecondary)
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _candidates.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (_, i) => _CandidateCard(
                        candidate: _candidates[i],
                        l10n: l10n,
                        onSend: () => _sendInvitation(i),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 24),
          ],
        ),
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  final _AiCandidate candidate;
  final AppLocalizations l10n;
  final VoidCallback onSend;

  const _CandidateCard({
    required this.candidate,
    required this.l10n,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final sent = candidate.status == _InviteStatus.sent;

    return IthakiCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar with match ring
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: IthakiTheme.placeholderBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: IthakiTheme.matchGreen, width: 2.5),
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
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: IthakiTheme.matchGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${candidate.matchPercent}%',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(candidate.name, style: IthakiTheme.bodySmallBold),
                    Text(candidate.jobTitle,
                        style: IthakiTheme.captionRegular),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(candidate.location, style: IthakiTheme.captionRegular),
              const Spacer(),
              Text(candidate.salary, style: IthakiTheme.bodySmallBold),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: IthakiTheme.matchBarBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const IthakiIcon('check',
                    size: 14, color: IthakiTheme.matchGradientHighStart),
                const SizedBox(width: 6),
                Text(
                  l10n.matchStrengthStrong,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.matchGradientHighStart,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: IthakiTheme.borderLight, height: 1),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: sent ? null : onSend,
              style: ElevatedButton.styleFrom(
                backgroundColor: sent
                    ? IthakiTheme.softGray
                    : IthakiTheme.primaryPurple,
                foregroundColor:
                    sent ? IthakiTheme.softGraphite : Colors.white,
                disabledBackgroundColor: IthakiTheme.softGray,
                disabledForegroundColor: IthakiTheme.softGraphite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                sent ? '✓ Sent' : l10n.aiMatcherSendInvitation,
                style: IthakiTheme.buttonLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filters sheet ─────────────────────────────────────────────────────────────

class _FiltersSheet extends StatelessWidget {
  final JobPost jobPost;
  const _FiltersSheet({required this.jobPost});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Prefilled from job post; granular filter values are mocked until backend ready
    final rows = [
      ('Job Category', jobPost.category),
      ('Role', jobPost.title),
      ('Location', 'Chalkidiki'),              // TODO: from job post when model includes location
      ('Experience Level', 'Entry'),            // TODO: from job post when model includes level
      ('Salary', jobPost.salary),
      ('Skills', 'Communication skill, + 7 more'), // TODO: from job post skills list
      ('Driving Licence', 'Filter Item 3; Filter Item 2;'), // TODO: from job post preferences
      ('Relocation', 'Filter Item 3; Filter Item 2;'),      // TODO: from job post preferences
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l10n.aiMatcherFilters, style: IthakiTheme.headingMedium),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const IthakiIcon('x-close', size: 20,
                      color: IthakiTheme.softGraphite),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...rows.map((row) => _FilterRow(label: row.$1, value: row.$2)),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final String label;
  final String value;
  const _FilterRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Text(label, style: IthakiTheme.bodySmallBold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: IthakiTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const IthakiIcon('arrow-down', size: 14,
                  color: IthakiTheme.softGraphite),
            ],
          ),
        ),
        const Divider(color: IthakiTheme.borderLight, height: 1),
      ],
    );
  }
}

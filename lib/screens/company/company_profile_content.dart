import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../models/company_models.dart';
import '../../providers/job_search_provider.dart';
import '../../routes.dart';
import 'widgets/company_profile_header.dart';
import 'widgets/company_profile_tabs.dart';

const companyProfileTabs = ['Vacancies', 'About Company', 'Events', 'Posts'];

class CompanyProfileContent extends ConsumerStatefulWidget {
  const CompanyProfileContent({
    super.key,
    required this.company,
    required this.tabController,
    required this.topOffset,
  });

  final CompanyProfile company;
  final TabController tabController;
  final double topOffset;

  @override
  ConsumerState<CompanyProfileContent> createState() =>
      _CompanyProfileContentState();
}

class _CompanyProfileContentState extends ConsumerState<CompanyProfileContent> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.tabController.index;
    widget.tabController.addListener(_syncTab);
  }

  @override
  void didUpdateWidget(covariant CompanyProfileContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabController != widget.tabController) {
      oldWidget.tabController.removeListener(_syncTab);
      _selectedTab = widget.tabController.index;
      widget.tabController.addListener(_syncTab);
    }
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_syncTab);
    super.dispose();
  }

  void _syncTab() {
    if (!mounted || widget.tabController.indexIsChanging) return;
    if (_selectedTab != widget.tabController.index) {
      setState(() => _selectedTab = widget.tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final company = widget.company;
    final searchState = ref.watch(jobSearchProvider).value;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyProfileHeader(
            company: company,
            topOffset: widget.topOffset,
          ),
          _CompanyTabsBar(
            controller: widget.tabController,
            onTap: (index) => setState(() => _selectedTab = index),
          ),
          _CompanyTabBody(
            selectedTab: _selectedTab,
            company: company,
            savedIds: searchState?.savedJobIds ?? {},
            onToggleSave: (id) =>
                ref.read(jobSearchProvider.notifier).toggleSaved(id),
            onViewJob: (id) => context.push(Routes.jobSearchDetailFor(id)),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 24),
        ],
      ),
    );
  }
}

class _CompanyTabsBar extends StatelessWidget {
  const _CompanyTabsBar({required this.controller, required this.onTap});

  final TabController controller;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: IthakiTheme.backgroundViolet,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
        ),
          child: TabBar(
            controller: controller,
            onTap: onTap,
            isScrollable: true,
            labelColor: IthakiTheme.primaryPurple,
          unselectedLabelColor: IthakiTheme.softGraphite,
          indicatorColor: IthakiTheme.primaryPurple,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Vacancies'),
            Tab(text: 'About Company'),
            Tab(text: 'Events'),
            Tab(text: 'Posts'),
          ],
        ),
      ),
    );
  }
}

class _CompanyTabBody extends StatelessWidget {
  const _CompanyTabBody({
    required this.selectedTab,
    required this.company,
    required this.savedIds,
    required this.onToggleSave,
    required this.onViewJob,
  });

  final int selectedTab;
  final CompanyProfile company;
  final Set<String> savedIds;
  final void Function(String id) onToggleSave;
  final void Function(String id) onViewJob;

  @override
  Widget build(BuildContext context) {
    return switch (selectedTab) {
      0 => CompanyVacanciesTab(
          vacancies: company.vacancies,
          culturalMatch: company.culturalMatch,
          savedIds: savedIds,
          onToggleSave: onToggleSave,
          onView: onViewJob,
        ),
      1 => CompanyAboutTab(company: company),
      2 => CompanyEventsTab(
          events: company.events,
          company: company,
          culturalMatch: company.culturalMatch,
        ),
      _ => CompanyPostsTab(
          posts: company.posts,
          company: company,
          culturalMatch: company.culturalMatch,
        ),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/search_item.dart';
import '../../theme/ithaki_theme.dart';
import '../../widgets/ithaki_app_bar.dart';
import '../../widgets/ithaki_button.dart';
import '../../widgets/ithaki_icon.dart';
import '../../widgets/ithaki_step_tabs.dart';
import '../../widgets/search_bottom_sheet.dart';

final _jobItems = [
  const SearchItem(id: 'accountant', label: 'Accountant', subtitle: 'Finance & Accounting'),
  const SearchItem(id: 'actor', label: 'Actor', subtitle: 'Entertainment'),
  const SearchItem(id: 'architect', label: 'Architect', subtitle: 'Construction'),
  const SearchItem(id: 'archivist', label: 'Archivist', subtitle: 'Information'),
  const SearchItem(id: 'attorney', label: 'Attorney', subtitle: 'Law & Legal Services'),
  const SearchItem(id: 'auditor', label: 'Auditor', subtitle: 'Finance & Accounting'),
  const SearchItem(id: 'web_developer', label: 'Web Developer', subtitle: 'IT & Development'),
  const SearchItem(id: 'welder', label: 'Welder', subtitle: 'Construction'),
  const SearchItem(id: 'wedding_planner', label: 'Wedding Planner', subtitle: 'Entertainment'),
  const SearchItem(id: 'web_designer', label: 'Web Designer', subtitle: 'IT & Development'),
  const SearchItem(id: 'weaver', label: 'Weaver', subtitle: 'Manufacturing'),
  const SearchItem(id: 'software_engineer', label: 'Software Engineer', subtitle: 'IT & Development'),
  const SearchItem(id: 'data_analyst', label: 'Data Analyst', subtitle: 'IT & Development'),
  const SearchItem(id: 'product_manager', label: 'Product Manager', subtitle: 'Management'),
  const SearchItem(id: 'ux_designer', label: 'UX Designer', subtitle: 'Design'),
];


class JobInterestsScreen extends StatefulWidget {
  const JobInterestsScreen({super.key});

  @override
  State<JobInterestsScreen> createState() => _JobInterestsScreenState();
}

class _JobInterestsScreenState extends State<JobInterestsScreen> {
  final List<SearchItem> _selected = [];

  void _openJobSearch() {
    if (_selected.length >= 5) return;
    final available = _jobItems.where((j) => !_selected.any((s) => s.id == j.id)).toList();
    SearchBottomSheet.show(
      context,
      'Select Job Interest',
      available,
      (item) => setState(() => _selected.add(item)),
    );
  }

  void _removeJob(String id) {
    setState(() => _selected.removeWhere((j) => j.id == id));
  }

  Widget _jobCard(SearchItem job) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EAFA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: IthakiTheme.primaryPurple, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: IthakiTheme.primaryPurple, width: 1),
              ),
              child: const Center(
                child: IthakiIcon('rocket', size: 20, color: IthakiTheme.primaryPurple),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary)),
                  if (job.subtitle.isNotEmpty)
                    Text(job.subtitle, style: const TextStyle(fontSize: 12, color: IthakiTheme.textSecondary)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _removeJob(job.id),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: IthakiTheme.textPrimary, width: 1),
                ),
                child: const Center(
                  child: IthakiIcon('delete', size: 18, color: IthakiTheme.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IthakiAppBar(showMenuAndAvatar: true),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IthakiStepTabs(
                steps: ['Location', 'Job Interests', 'Preferences', 'Values'],
                currentIndex: 1,
                completedUpTo: 0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Job Interests', style: IthakiTheme.headingLarge),
                    const SizedBox(height: 8),
                    const Text(
                      'Select job types or fields that match your professional interests. You can add up to 5 different fields.',
                      style: IthakiTheme.bodyRegular,
                    ),
                    const SizedBox(height: 24),
                    // Selected job cards
                    ..._selected.map(_jobCard),
                    // Add button or initial trigger
                    if (_selected.isEmpty)
                      GestureDetector(
                        onTap: _openJobSearch,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: IthakiTheme.borderLight),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                child: Text('Search and add job interest', style: TextStyle(fontSize: 14, color: IthakiTheme.textHint)),
                              ),
                              IthakiIcon('search', size: 20, color: IthakiTheme.textHint),
                            ],
                          ),
                        ),
                      )
                    else if (_selected.length < 5)
                      GestureDetector(
                        onTap: _openJobSearch,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: IthakiTheme.textPrimary),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IthakiIcon('plus', size: 14, color: IthakiTheme.textPrimary),
                              SizedBox(width: 6),
                              Text('Add Another Job Interest', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: IthakiTheme.textPrimary)),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 40),
                    IthakiButton(
                      'Continue',
                      onPressed: () => context.go('/setup/preferences'),
                    ),
                    const SizedBox(height: 12),
                    IthakiButton(
                      'Back',
                      variant: IthakiButtonVariant.outline,
                      onPressed: () => context.go('/setup/location'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/employer_dashboard_models.dart';

enum _Step { basics, skills, description, preferences, review }

class _LanguageEntry {
  String language = '';
  String proficiency = '';
}

class EmployerEditJobPostScreen extends ConsumerStatefulWidget {
  final JobPost jobPost;
  const EmployerEditJobPostScreen({super.key, required this.jobPost});

  @override
  ConsumerState<EmployerEditJobPostScreen> createState() =>
      _EmployerEditJobPostScreenState();
}

class _EmployerEditJobPostScreenState
    extends ConsumerState<EmployerEditJobPostScreen> {
  final _pageController = PageController();
  _Step _currentStep = _Step.basics;

  // Basics fields
  late final TextEditingController _nameCtrl;
  String _industry = 'Retail';
  final String _location = 'Thessaloniki';
  String _experienceLevel = 'Entry';
  String _jobType = 'Full-time';
  String _workplaceType = 'Office';
  String _salaryFrom = '1,000';
  String _salaryTo = '1,500';
  bool _setSalaryRange = true;
  bool _setDeadline = true;
  DateTime? _deadline;

  // Skills fields
  final List<String> _skills = [];
  final TextEditingController _skillInputCtrl = TextEditingController();
  final List<_LanguageEntry> _languages = [_LanguageEntry()];
  String _computerSkills = 'Advanced';
  bool _drivingLicence = false;
  String _drivingCategory = 'Category B';

  // Description fields
  final TextEditingController _aboutCtrl = TextEditingController();
  final TextEditingController _responsibilitiesCtrl = TextEditingController();
  final TextEditingController _requirementsCtrl = TextEditingController();
  final TextEditingController _niceToHaveCtrl = TextEditingController();
  final TextEditingController _weOfferCtrl = TextEditingController();

  // Preferences fields
  bool _requireCoverLetter = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.jobPost.title);
    _deadline = DateTime.now().add(const Duration(days: 60));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _skillInputCtrl.dispose();
    _aboutCtrl.dispose();
    _responsibilitiesCtrl.dispose();
    _requirementsCtrl.dispose();
    _niceToHaveCtrl.dispose();
    _weOfferCtrl.dispose();
    super.dispose();
  }

  void _goToStep(_Step step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    if (_currentStep.index < _Step.values.length - 1) {
      _goToStep(_Step.values[_currentStep.index + 1]);
    }
  }

  void _back() {
    if (_currentStep.index > 0) {
      _goToStep(_Step.values[_currentStep.index - 1]);
    }
  }

  // ignore: invalid_use_of_protected_member
  void rebuild(VoidCallback fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        showMenuAndAvatar: false,
        showBackButton: true,
        onMenuPressed: () => context.pop(),
      ),
      bottomNavigationBar: _EditBottomBar(
        l10n: l10n,
        onPublish: () => context.pop('published'),
        onSaveDraft: () {
          // TODO: persist draft when backend is ready
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Save as Draft — coming soon')),
          );
        },
        onDelete: () {
          // TODO: delete job post when backend is ready
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Delete — coming soon')),
          );
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _BasicsStep(this, l10n),
                _SkillsStep(this, l10n),
                _DescriptionStep(this, l10n),
                _PreferencesStep(this, l10n),
                _ReviewStep(this, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final _Step current;
  const _StepIndicator(this.current);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [
      l10n.editStepBasics,
      l10n.editStepSkills,
      l10n.editStepDescription,
      l10n.editStepPreferences,
      l10n.editStepReview,
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_Step.values.length, (i) {
          final step = _Step.values[i];
          final isActive = step == current;
          final isCompleted = step.index < current.index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive || isCompleted
                    ? IthakiTheme.primaryPurple
                    : IthakiTheme.softGray,
                borderRadius: BorderRadius.circular(20),
                border: isActive
                    ? Border.all(color: IthakiTheme.primaryPurple, width: 2)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompleted) ...[
                    const IthakiIcon('check', size: 13, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive || isCompleted
                          ? Colors.white
                          : IthakiTheme.softGraphite,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BasicsStep extends StatelessWidget {
  final _EmployerEditJobPostScreenState s;
  final AppLocalizations l10n;
  const _BasicsStep(this.s, this.l10n);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.editJobPostTitle, style: IthakiTheme.headingLarge),
          const SizedBox(height: 4),
          Text(l10n.editJobPostSubtitle, style: IthakiTheme.bodySecondary),
          const SizedBox(height: 16),
          _StepIndicator(s._currentStep),
          const SizedBox(height: 24),
          IthakiCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.editStepBasics, style: IthakiTheme.headingMedium),
                const SizedBox(height: 16),
                _FieldLabel(l10n.editJobPostNameLabel),
                TextField(
                  controller: s._nameCtrl,
                  style: IthakiTheme.bodySmall,
                  decoration: _inputDeco(),
                ),
                const SizedBox(height: 12),
                _FieldLabel(l10n.editIndustryLabel),
                _DropdownField(
                  value: s._industry,
                  items: const ['Retail', 'Transportation & Logistics',
                    'Marketing', 'Technology', 'Healthcare'],
                  onChanged: (v) => s.rebuild(() => s._industry = v!),
                ),
                const SizedBox(height: 12),
                _FieldLabel('Location'),
                TextField(
                  controller: TextEditingController(text: s._location),
                  style: IthakiTheme.bodySmall,
                  readOnly: true,
                  decoration: _inputDeco(
                    suffix: const IthakiIcon('location', size: 18,
                        color: IthakiTheme.softGraphite),
                  ),
                ),
                const SizedBox(height: 12),
                _FieldLabel(l10n.editExperienceLevelLabel),
                _DropdownField(
                  value: s._experienceLevel,
                  items: const ['Entry', 'Junior', 'Mid', 'Senior', 'Lead'],
                  onChanged: (v) => s.rebuild(() => s._experienceLevel = v!),
                ),
                const SizedBox(height: 12),
                _FieldLabel(l10n.editJobTypeLabel),
                _DropdownField(
                  value: s._jobType,
                  items: const ['Full-time', 'Part-time', 'Contract',
                    'Internship'],
                  onChanged: (v) => s.rebuild(() => s._jobType = v!),
                ),
                const SizedBox(height: 12),
                _FieldLabel(l10n.editWorkplaceTypeLabel),
                _DropdownField(
                  value: s._workplaceType,
                  items: const ['Office', 'Remote', 'Hybrid'],
                  onChanged: (v) => s.rebuild(() => s._workplaceType = v!),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(l10n.editSalaryFromLabel),
                      TextField(
                        controller:
                            TextEditingController(text: s._salaryFrom),
                        keyboardType: TextInputType.number,
                        style: IthakiTheme.bodySmall,
                        decoration: _inputDeco(suffix: const Text('€')),
                        onChanged: (v) => s._salaryFrom = v,
                      ),
                    ],
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(l10n.editSalaryToLabel),
                      TextField(
                        controller:
                            TextEditingController(text: s._salaryTo),
                        keyboardType: TextInputType.number,
                        style: IthakiTheme.bodySmall,
                        decoration: _inputDeco(suffix: const Text('€')),
                        onChanged: (v) => s._salaryTo = v,
                      ),
                    ],
                  )),
                ]),
                CheckboxListTile(
                  value: s._setSalaryRange,
                  onChanged: (v) => s.rebuild(() => s._setSalaryRange = v!),
                  title: Text(l10n.editSetSalaryRange,
                      style: IthakiTheme.bodySmall),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: IthakiTheme.primaryPurple,
                ),
                CheckboxListTile(
                  value: s._setDeadline,
                  onChanged: (v) => s.rebuild(() => s._setDeadline = v!),
                  title: Text(l10n.editSetDeadline,
                      style: IthakiTheme.bodySmall),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: IthakiTheme.primaryPurple,
                ),
                if (s._setDeadline) ...[
                  _FieldLabel('Deadline Date'),
                  TextField(
                    readOnly: true,
                    style: IthakiTheme.bodySmall,
                    controller: TextEditingController(
                      text: s._deadline != null
                          ? '${s._deadline!.day.toString().padLeft(2, '0')}-'
                            '${s._deadline!.month.toString().padLeft(2, '0')}-'
                            '${s._deadline!.year}'
                          : '',
                    ),
                    decoration: _inputDeco(
                      suffix: const IthakiIcon('calendar', size: 18,
                          color: IthakiTheme.softGraphite),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: s._deadline ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        s.rebuild(() => s._deadline = picked);
                      }
                    },
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: IthakiButton('Continue', onPressed: s._next),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillsStep extends StatelessWidget {
  final _EmployerEditJobPostScreenState s;
  final AppLocalizations l10n;
  const _SkillsStep(this.s, this.l10n);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.editJobPostTitle, style: IthakiTheme.headingLarge),
          const SizedBox(height: 4),
          Text(l10n.editJobPostSubtitle, style: IthakiTheme.bodySecondary),
          const SizedBox(height: 16),
          _StepIndicator(s._currentStep),
          const SizedBox(height: 24),
          IthakiCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.editSkillsTitle, style: IthakiTheme.headingMedium),
                const SizedBox(height: 8),
                Text(l10n.editSkillsDescription,
                    style: IthakiTheme.bodySecondary),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const IthakiIcon('ai', size: 16,
                      color: IthakiTheme.primaryPurple),
                  label: Text(l10n.editAiSkillsSuggestions,
                      style: IthakiTheme.bodySmall
                          .copyWith(color: IthakiTheme.primaryPurple)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: IthakiTheme.primaryPurple),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: s._skills.map((skill) => Chip(
                    label: Text(skill, style: IthakiTheme.bodySmall),
                    onDeleted: () =>
                        s.rebuild(() => s._skills.remove(skill)),
                    deleteIcon: const IthakiIcon('x', size: 14,
                        color: IthakiTheme.softGraphite),
                    backgroundColor: IthakiTheme.softGray,
                    side: BorderSide.none,
                  )).toList(),
                ),
                TextField(
                  controller: s._skillInputCtrl,
                  style: IthakiTheme.bodySmall,
                  decoration: _inputDeco(hint: l10n.editSkillsHint),
                  onSubmitted: (v) {
                    if (v.trim().isNotEmpty) {
                      s.rebuild(() {
                        s._skills.add(v.trim());
                        s._skillInputCtrl.clear();
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                Text(l10n.editLanguagesTitle,
                    style: IthakiTheme.headingMedium),
                const SizedBox(height: 12),
                ...s._languages.asMap().entries.map((e) {
                  final i = e.key;
                  final lang = e.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DropdownField(
                            value: lang.language.isEmpty
                                ? null : lang.language,
                            hint: l10n.editLanguageLabel,
                            items: const ['Greek', 'English', 'Arabic',
                              'French', 'German', 'Spanish'],
                            onChanged: (v) =>
                                s.rebuild(() => lang.language = v!),
                          ),
                          const SizedBox(height: 8),
                          _DropdownField(
                            value: lang.proficiency.isEmpty
                                ? null : lang.proficiency,
                            hint: l10n.editProficiencyLabel,
                            items: const ['Basic', 'Conversational', 'Fluent',
                              'Native', 'Intermediate'],
                            onChanged: (v) =>
                                s.rebuild(() => lang.proficiency = v!),
                          ),
                        ],
                      )),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () =>
                            s.rebuild(() => s._languages.removeAt(i)),
                        child: const IthakiIcon('delete', size: 20,
                            color: IthakiTheme.softGraphite),
                      ),
                    ]),
                  );
                }),
                OutlinedButton.icon(
                  onPressed: () =>
                      s.rebuild(() => s._languages.add(_LanguageEntry())),
                  icon: const IthakiIcon('plus', size: 16,
                      color: IthakiTheme.textPrimary),
                  label: Text(l10n.editAddLanguage,
                      style: IthakiTheme.bodySmall),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: IthakiTheme.borderLight),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    foregroundColor: IthakiTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(l10n.editCompetenciesTitle,
                    style: IthakiTheme.headingMedium),
                const SizedBox(height: 12),
                _FieldLabel(l10n.editComputerSkillsLabel),
                _DropdownField(
                  value: s._computerSkills,
                  items: const ['Basic', 'Intermediate', 'Advanced'],
                  onChanged: (v) =>
                      s.rebuild(() => s._computerSkills = v!),
                ),
                CheckboxListTile(
                  value: s._drivingLicence,
                  onChanged: (v) =>
                      s.rebuild(() => s._drivingLicence = v!),
                  title: Text(l10n.editDrivingLicence,
                      style: IthakiTheme.bodySmall),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: IthakiTheme.primaryPurple,
                ),
                if (s._drivingLicence) ...[
                  _FieldLabel(l10n.editDrivingLicenceCategory),
                  _DropdownField(
                    value: s._drivingCategory,
                    items: const ['Category A', 'Category B', 'Category C',
                      'Category D'],
                    onChanged: (v) =>
                        s.rebuild(() => s._drivingCategory = v!),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: IthakiButton('Continue', onPressed: s._next),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: IthakiOutlineButton('Back', onPressed: s._back),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionStep extends StatelessWidget {
  final _EmployerEditJobPostScreenState s;
  final AppLocalizations l10n;
  const _DescriptionStep(this.s, this.l10n);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.editJobPostTitle, style: IthakiTheme.headingLarge),
          const SizedBox(height: 4),
          Text(l10n.editJobPostSubtitle, style: IthakiTheme.bodySecondary),
          const SizedBox(height: 16),
          _StepIndicator(s._currentStep),
          const SizedBox(height: 24),
          IthakiCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final entry in [
                  (l10n.editAboutRole, s._aboutCtrl),
                  (l10n.editResponsibilities, s._responsibilitiesCtrl),
                  (l10n.editRequirements, s._requirementsCtrl),
                  (l10n.editNiceToHave, s._niceToHaveCtrl),
                  (l10n.editWeOffer, s._weOfferCtrl),
                ]) ...[
                  _FieldLabel(entry.$1),
                  TextField(
                    controller: entry.$2,
                    style: IthakiTheme.bodySmall,
                    maxLines: null,
                    minLines: 4,
                    decoration: _inputDeco(),
                  ),
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  width: double.infinity, height: 52,
                  child: IthakiButton('Continue', onPressed: s._next),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: IthakiOutlineButton('Back', onPressed: s._back),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferencesStep extends StatelessWidget {
  final _EmployerEditJobPostScreenState s;
  final AppLocalizations l10n;
  const _PreferencesStep(this.s, this.l10n);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.editJobPostTitle, style: IthakiTheme.headingLarge),
          const SizedBox(height: 4),
          Text(l10n.editJobPostSubtitle, style: IthakiTheme.bodySecondary),
          const SizedBox(height: 16),
          _StepIndicator(s._currentStep),
          const SizedBox(height: 24),
          IthakiCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.editCoverLetterTitle,
                    style: IthakiTheme.headingMedium),
                const SizedBox(height: 4),
                Text(l10n.editCoverLetterDescription,
                    style: IthakiTheme.bodySecondary),
                CheckboxListTile(
                  value: s._requireCoverLetter,
                  onChanged: (v) =>
                      s.rebuild(() => s._requireCoverLetter = v!),
                  title: Text(l10n.editRequireCoverLetter,
                      style: IthakiTheme.bodySmall),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: IthakiTheme.primaryPurple,
                ),
                const SizedBox(height: 20),
                Text(l10n.editScreeningQuestionsTitle,
                    style: IthakiTheme.headingMedium),
                const SizedBox(height: 4),
                Text(l10n.editScreeningQuestionsDescription,
                    style: IthakiTheme.bodySecondary),
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  child: IthakiButton(l10n.editAddScreeningQuestions,
                      onPressed: () {}),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: IthakiButton('Continue', onPressed: s._next),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: IthakiOutlineButton('Back', onPressed: s._back),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewStep extends StatelessWidget {
  final _EmployerEditJobPostScreenState s;
  final AppLocalizations l10n;
  const _ReviewStep(this.s, this.l10n);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.editJobPostTitle, style: IthakiTheme.headingLarge),
          const SizedBox(height: 4),
          Text(l10n.editJobPostSubtitle, style: IthakiTheme.bodySecondary),
          const SizedBox(height: 16),
          _StepIndicator(s._currentStep),
          const SizedBox(height: 24),
          IthakiCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.editStepBasics, style: IthakiTheme.headingMedium),
                const SizedBox(height: 8),
                Text(
                  '${s._nameCtrl.text} · ${s._jobType} · ${s._location}',
                  style: IthakiTheme.bodySmall,
                ),
                Text(
                  '${s._salaryFrom}–${s._salaryTo} € · ${s._experienceLevel}',
                  style: IthakiTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                IthakiOutlineButton(l10n.editJobBasicsButton,
                    onPressed: () => s._goToStep(_Step.basics)),
                const Divider(height: 24),

                Text(l10n.editStepSkills, style: IthakiTheme.headingMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: s._skills.map((sk) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: IthakiTheme.softGray,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(sk, style: IthakiTheme.captionRegular),
                  )).toList(),
                ),
                const SizedBox(height: 8),
                IthakiOutlineButton(l10n.editSkillsButton,
                    onPressed: () => s._goToStep(_Step.skills)),
                const Divider(height: 24),

                Text(l10n.editStepDescription,
                    style: IthakiTheme.headingMedium),
                const SizedBox(height: 8),
                if (s._aboutCtrl.text.isNotEmpty)
                  Text(
                    s._aboutCtrl.text.length > 120
                        ? '${s._aboutCtrl.text.substring(0, 120)}…'
                        : s._aboutCtrl.text,
                    style: IthakiTheme.bodySmall,
                  ),
                const SizedBox(height: 8),
                IthakiOutlineButton(l10n.editDescriptionButton,
                    onPressed: () => s._goToStep(_Step.description)),
                const Divider(height: 24),

                Text(l10n.editStepPreferences,
                    style: IthakiTheme.headingMedium),
                const SizedBox(height: 8),
                Text(
                  s._requireCoverLetter
                      ? 'Cover letter required'
                      : 'Cover letter not required',
                  style: IthakiTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                IthakiOutlineButton(l10n.editCoverLetterPrefsButton,
                    onPressed: () => s._goToStep(_Step.preferences)),
                const Divider(height: 24),

                IthakiOutlineButton(l10n.editScreeningButton,
                    onPressed: () => s._goToStep(_Step.preferences)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: IthakiOutlineButton('Back', onPressed: s._back),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

InputDecoration _inputDeco({String? hint, Widget? suffix}) => InputDecoration(
      hintText: hint,
      hintStyle:
          IthakiTheme.bodySmall.copyWith(color: IthakiTheme.textSecondary),
      suffixIcon: suffix != null
          ? Padding(
              padding: const EdgeInsets.only(right: 12),
              child: suffix,
            )
          : null,
      suffixIconConstraints: const BoxConstraints(minWidth: 0),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: IthakiTheme.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: IthakiTheme.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: IthakiTheme.primaryPurple),
      ),
      filled: true,
      fillColor: IthakiTheme.backgroundWhite,
    );

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(label, style: IthakiTheme.bodySmallBold),
      );
}

class _DropdownField extends StatelessWidget {
  final String? value;
  final String? hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    this.value,
    this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        border: Border.all(color: IthakiTheme.borderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: hint != null
              ? Text(hint!,
                  style: IthakiTheme.bodySmall
                      .copyWith(color: IthakiTheme.textSecondary))
              : null,
          style: IthakiTheme.bodySmall,
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
          icon: const IthakiIcon('arrow-down', size: 16,
              color: IthakiTheme.softGraphite),
        ),
      ),
    );
  }
}

// ── Edit screen persistent bottom bar ────────────────────────────────────────

class _EditBottomBar extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onPublish;
  final VoidCallback onSaveDraft;
  final VoidCallback onDelete;

  const _EditBottomBar({
    required this.l10n,
    required this.onPublish,
    required this.onSaveDraft,
    required this.onDelete,
  });

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
                  onPressed: onPublish,
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
                      const IthakiIcon('rocket', size: 16, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(l10n.publishJobPostButton,
                          style: IthakiTheme.buttonLabel),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'draft') onSaveDraft();
                if (value == 'delete') onDelete();
              },
              offset: const Offset(0, -110),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'draft',
                  child: Row(children: [
                    const IthakiIcon('resume',
                        size: 18, color: IthakiTheme.textPrimary),
                    const SizedBox(width: 10),
                    const Text('Save as Draft'),
                  ]),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    const IthakiIcon('delete',
                        size: 18, color: IthakiTheme.textPrimary),
                    const SizedBox(width: 10),
                    Text(l10n.jobDetailDelete),
                  ]),
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
            ),
          ],
        ),
      ),
    );
  }
}

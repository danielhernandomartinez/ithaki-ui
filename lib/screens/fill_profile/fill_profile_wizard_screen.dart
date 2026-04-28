import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../providers/fill_profile_provider.dart';
import '../../providers/profile_provider.dart';
import '../../routes.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const _kTotalSteps = 7;

const _stepTitles = [
  'Basics',
  'About Me',
  'Skills',
  'Work Experience',
  'Education',
  'Languages',
  'Documents',
];

const _stepDescriptions = [
  'Tell us a bit about yourself.',
  'Write a short bio so employers know who you are.',
  'Add your hard and soft skills.',
  'Add your work experience, or let us know you\'re just starting out.',
  'Add your education background.',
  'Which languages do you speak?',
  'Upload your CV or any relevant documents.',
];

const _levelOptions = ['Native', 'Fluent', 'Advanced', 'Intermediate', 'Basic'];

// ─── Main screen ─────────────────────────────────────────────────────────────

class FillProfileWizardScreen extends ConsumerStatefulWidget {
  const FillProfileWizardScreen({super.key});

  @override
  ConsumerState<FillProfileWizardScreen> createState() =>
      _FillProfileWizardScreenState();
}

class _FillProfileWizardScreenState
    extends ConsumerState<FillProfileWizardScreen> {
  int _step = 0; // 0-based
  bool _dirty = false;

  // Step 0 — Basics
  final _nameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();

  // Step 1 — About Me
  final _bioCtrl = TextEditingController();

  // Step 2 — Skills
  final _skillInputCtrl = TextEditingController();
  int _skillTab = 0; // 0 = hard, 1 = soft
  final List<String> _hardSkills = [];
  final List<String> _softSkills = [];

  // Step 3 — Work Experience
  bool _noWorkExp = false;
  final _jobTitleCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _workStartCtrl = TextEditingController();
  final _workEndCtrl = TextEditingController();
  bool _currentJob = false;

  // Step 4 — Education
  bool _noEducation = false;
  final _degreeCtrl = TextEditingController();
  final _institutionCtrl = TextEditingController();
  final _eduStartCtrl = TextEditingController();
  final _eduEndCtrl = TextEditingController();

  // Step 5 — Languages
  final _langNameCtrl = TextEditingController();
  String _langLevel = 'Fluent';
  final List<_LangEntry> _languages = [];

  // Step 6 — Documents
  final List<String> _docNames = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _dobCtrl.dispose();
    _bioCtrl.dispose();
    _skillInputCtrl.dispose();
    _jobTitleCtrl.dispose();
    _companyCtrl.dispose();
    _workStartCtrl.dispose();
    _workEndCtrl.dispose();
    _degreeCtrl.dispose();
    _institutionCtrl.dispose();
    _eduStartCtrl.dispose();
    _eduEndCtrl.dispose();
    _langNameCtrl.dispose();
    super.dispose();
  }

  // ─── Navigation ────────────────────────────────────────────────────────────

  Future<void> _saveCurrentStep() async {
    switch (_step) {
      case 0:
        if (_nameCtrl.text.trim().isEmpty) return;
        final basics = ref.read(profileBasicsProvider).value;
        if (basics == null) return; // provider not yet loaded
        await ref.read(profileBasicsProvider.notifier).save(
              firstName: _nameCtrl.text.trim(),
              lastName: _lastNameCtrl.text.trim(),
              dateOfBirth: _dobCtrl.text.trim(),
              gender: basics.gender,
              citizenship: basics.citizenship,
              citizenshipCode: basics.citizenshipCode.isNotEmpty
                  ? basics.citizenshipCode
                  : null,
              residence: basics.residence,
              residenceCode:
                  basics.residenceCode.isNotEmpty ? basics.residenceCode : null,
              status: basics.status,
              relocationReadiness: basics.relocationReadiness,
              photoUrl: basics.photoUrl,
            );
        break;
      case 1:
        if (_bioCtrl.text.trim().isNotEmpty) {
          await ref
              .read(profileAboutMeProvider.notifier)
              .save(_bioCtrl.text.trim());
        }
        break;
      case 2:
        if (_hardSkills.isNotEmpty || _softSkills.isNotEmpty) {
          await ref
              .read(profileSkillsProvider.notifier)
              .updateSkills(List.of(_hardSkills), List.of(_softSkills));
        }
        break;
      case 3:
        if (!_noWorkExp &&
            _jobTitleCtrl.text.trim().isNotEmpty &&
            _companyCtrl.text.trim().isNotEmpty &&
            _workStartCtrl.text.trim().isNotEmpty) {
          await ref.read(profileWorkExperiencesProvider.notifier).add(
                WorkExperience(
                  jobTitle: _jobTitleCtrl.text.trim(),
                  companyName: _companyCtrl.text.trim(),
                  location: '',
                  experienceLevel: '',
                  workplace: '',
                  jobType: '',
                  startDate: _workStartCtrl.text.trim(),
                  endDate: _currentJob ? null : _workEndCtrl.text.trim(),
                  currentlyWorkHere: _currentJob,
                ),
              );
        }
        break;
      case 4:
        if (!_noEducation &&
            _institutionCtrl.text.trim().isNotEmpty &&
            _degreeCtrl.text.trim().isNotEmpty &&
            _eduStartCtrl.text.trim().isNotEmpty) {
          await ref.read(profileEducationsProvider.notifier).add(
                Education(
                  institutionName: _institutionCtrl.text.trim(),
                  fieldOfStudy: _degreeCtrl.text.trim(),
                  location: '',
                  degreeType: '',
                  startDate: _eduStartCtrl.text.trim(),
                  endDate: _eduEndCtrl.text.trim().isNotEmpty
                      ? _eduEndCtrl.text.trim()
                      : null,
                ),
              );
        }
        break;
      case 5:
        if (_languages.isNotEmpty) {
          await ref
              .read(profileSkillsProvider.notifier)
              .updateLanguages(_languages
                  .map((e) => Language(language: e.name, proficiency: e.level))
                  .toList());
        }
        break;
      case 6:
        // Documents: handled inline via file picker
        break;
    }
  }

  Future<void> _onNext() async {
    await _saveCurrentStep();
    if (!mounted) return;
    if (_step < _kTotalSteps - 1) {
      setState(() {
        _step++;
        _dirty = false;
      });
    } else {
      await _finish();
    }
  }

  Future<void> _finish() async {
    await ref.read(fillProfileDoneProvider.notifier).markDone();
    if (mounted) context.go(Routes.profile);
  }

  void _onBack() {
    if (_step == 0) {
      if (_dirty) {
        _showCloseModal();
      } else {
        context.pop();
      }
    } else {
      setState(() => _step--);
    }
  }

  void _showCloseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CloseModal(
        onClose: () async {
          Navigator.of(context).pop();
          await ref.read(fillProfileDoneProvider.notifier).markDone();
          if (mounted) context.go(Routes.home);
        },
        onStay: () => Navigator.of(context).pop(),
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => _onBack(),
      child: Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        body: SafeArea(
          child: Column(
            children: [
              _Header(
                step: _step,
                onClose: _showCloseModal,
                onBack: _step > 0 ? () => setState(() => _step--) : null,
              ),
              _ProgressBar(step: _step),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _stepTitles[_step],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: IthakiTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _stepDescriptions[_step],
                        style: const TextStyle(
                          fontSize: 14,
                          color: IthakiTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildStep(),
                    ],
                  ),
                ),
              ),
              _Footer(
                step: _step,
                onNext: _onNext,
                onSkip: () => setState(() {
                  _step++;
                  _dirty = false;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _BasicsStep(
          nameCtrl: _nameCtrl,
          lastNameCtrl: _lastNameCtrl,
          dobCtrl: _dobCtrl,
          onChanged: () => setState(() => _dirty = true),
        );
      case 1:
        return _AboutMeStep(
          bioCtrl: _bioCtrl,
          onChanged: () => setState(() => _dirty = true),
        );
      case 2:
        return _SkillsStep(
          tab: _skillTab,
          onTabChanged: (t) => setState(() => _skillTab = t),
          inputCtrl: _skillInputCtrl,
          hardSkills: _hardSkills,
          softSkills: _softSkills,
          onSkillAdded: (skill) => setState(() {
            if (_skillTab == 0) {
              if (!_hardSkills.contains(skill)) _hardSkills.add(skill);
            } else {
              if (!_softSkills.contains(skill)) _softSkills.add(skill);
            }
            _skillInputCtrl.clear();
            _dirty = true;
          }),
          onSkillRemoved: (skill, isHard) => setState(() {
            isHard ? _hardSkills.remove(skill) : _softSkills.remove(skill);
          }),
        );
      case 3:
        return _WorkExperienceStep(
          noWorkExp: _noWorkExp,
          onNoExpToggled: (v) => setState(() => _noWorkExp = v),
          jobTitleCtrl: _jobTitleCtrl,
          companyCtrl: _companyCtrl,
          startCtrl: _workStartCtrl,
          endCtrl: _workEndCtrl,
          currentJob: _currentJob,
          onCurrentJobToggled: (v) => setState(() => _currentJob = v),
          onChanged: () => setState(() => _dirty = true),
        );
      case 4:
        return _EducationStep(
          noEducation: _noEducation,
          onNoEduToggled: (v) => setState(() => _noEducation = v),
          degreeCtrl: _degreeCtrl,
          institutionCtrl: _institutionCtrl,
          startCtrl: _eduStartCtrl,
          endCtrl: _eduEndCtrl,
          onChanged: () => setState(() => _dirty = true),
        );
      case 5:
        return _LanguagesStep(
          langNameCtrl: _langNameCtrl,
          langLevel: _langLevel,
          languages: _languages,
          onLevelChanged: (v) => setState(() => _langLevel = v),
          onAdd: () {
            final name = _langNameCtrl.text.trim();
            if (name.isEmpty) return;
            setState(() {
              _languages.add(_LangEntry(name: name, level: _langLevel));
              _langNameCtrl.clear();
              _dirty = true;
            });
          },
          onRemove: (i) => setState(() => _languages.removeAt(i)),
        );
      case 6:
        return _DocumentsStep(
          docNames: _docNames,
          onPick: () async {
            final result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              type: FileType.custom,
              allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg'],
            );
            if (result == null) return;
            setState(() {
              for (final f in result.files) {
                if (!_docNames.contains(f.name)) _docNames.add(f.name);
              }
              _dirty = true;
            });
          },
          onRemove: (i) => setState(() => _docNames.removeAt(i)),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final int step;
  final VoidCallback onClose;
  final VoidCallback? onBack;

  const _Header({required this.step, required this.onClose, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              icon: const IthakiIcon('arrow-down', size: 20,
                  color: IthakiTheme.textPrimary),
            )
          else
            const SizedBox(width: 40),
          Expanded(
            child: Text(
              'Step ${step + 1} of $_kTotalSteps',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: IthakiTheme.textSecondary,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: IthakiTheme.textPrimary, size: 22),
          ),
        ],
      ),
    );
  }
}

// ─── Progress bar ─────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final int step;
  const _ProgressBar({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: IthakiTheme.borderLight,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: (step + 1) / _kTotalSteps,
        child: Container(
          decoration: BoxDecoration(
            color: IthakiTheme.primaryPurple,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  final int step;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _Footer(
      {required this.step, required this.onNext, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    final isLast = step == _kTotalSteps - 1;
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.viewPaddingOf(context).bottom + 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IthakiButton(
            isLast ? 'Finish' : 'Next',
            onPressed: onNext,
          ),
          if (!isLast) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onSkip,
              child: const Text(
                'Skip this step',
                style: TextStyle(
                  color: IthakiTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Close modal ─────────────────────────────────────────────────────────────

class _CloseModal extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onStay;
  const _CloseModal({required this.onClose, required this.onStay});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.fromLTRB(
          24, 28, 24, MediaQuery.viewPaddingOf(context).bottom + 24),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Close without saving?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your progress on the current step will be lost. Completed steps are already saved.',
            style: TextStyle(
              fontSize: 15,
              color: IthakiTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          IthakiButton('Close', variant: IthakiButtonVariant.outline,
              onPressed: onClose),
          const SizedBox(height: 10),
          IthakiButton('Stay', onPressed: onStay),
        ],
      ),
    );
  }
}

// ─── Step widgets ─────────────────────────────────────────────────────────────

class _BasicsStep extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController dobCtrl;
  final VoidCallback onChanged;

  const _BasicsStep({
    required this.nameCtrl,
    required this.lastNameCtrl,
    required this.dobCtrl,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          IthakiTextField(
            label: 'First Name',
            hint: 'Your first name',
            controller: nameCtrl,
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 12),
          IthakiTextField(
            label: 'Last Name',
            hint: 'Your last name',
            controller: lastNameCtrl,
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 12),
          IthakiTextField(
            label: 'Date of Birth',
            hint: 'DD-MM-YYYY',
            controller: dobCtrl,
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(1995),
                firstDate: DateTime(1940),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                dobCtrl.text =
                    '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
                onChanged();
              }
            },
            suffixIcon: const IthakiIcon('calendar',
                size: 16, color: IthakiTheme.softGraphite),
          ),
        ],
      ),
    );
  }
}

class _AboutMeStep extends StatelessWidget {
  final TextEditingController bioCtrl;
  final VoidCallback onChanged;

  const _AboutMeStep({required this.bioCtrl, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: bioCtrl,
            maxLines: null,
            minLines: 6,
            maxLength: 1000,
            buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                null,
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              hintText: 'Write a short bio about yourself...',
              hintStyle: const TextStyle(
                  color: IthakiTheme.softGraphite, fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    const BorderSide(color: IthakiTheme.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    const BorderSide(color: IthakiTheme.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                    color: IthakiTheme.primaryPurple, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: ValueListenableBuilder(
              valueListenable: bioCtrl,
              builder: (_, v, __) => Text(
                '${v.text.length} / 1000',
                style: const TextStyle(
                    fontSize: 11, color: IthakiTheme.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillsStep extends StatelessWidget {
  final int tab;
  final ValueChanged<int> onTabChanged;
  final TextEditingController inputCtrl;
  final List<String> hardSkills;
  final List<String> softSkills;
  final ValueChanged<String> onSkillAdded;
  final void Function(String skill, bool isHard) onSkillRemoved;

  const _SkillsStep({
    required this.tab,
    required this.onTabChanged,
    required this.inputCtrl,
    required this.hardSkills,
    required this.softSkills,
    required this.onSkillAdded,
    required this.onSkillRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final currentList = tab == 0 ? hardSkills : softSkills;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs
          Row(
            children: [
              _SkillTab(
                label: 'Hard Skills',
                selected: tab == 0,
                onTap: () => onTabChanged(0),
              ),
              const SizedBox(width: 20),
              _SkillTab(
                label: 'Soft Skills',
                selected: tab == 1,
                onTap: () => onTabChanged(1),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: inputCtrl,
                  decoration: InputDecoration(
                    hintText:
                        tab == 0 ? 'e.g. Microsoft Excel' : 'e.g. Teamwork',
                    hintStyle: const TextStyle(
                        color: IthakiTheme.softGraphite, fontSize: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: IthakiTheme.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: IthakiTheme.primaryPurple, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                  onSubmitted: (v) {
                    if (v.trim().isNotEmpty) onSkillAdded(v.trim());
                  },
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (inputCtrl.text.trim().isNotEmpty) {
                    onSkillAdded(inputCtrl.text.trim());
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: IthakiTheme.primaryPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: IthakiIcon('plus', size: 18,
                        color: IthakiTheme.backgroundWhite),
                  ),
                ),
              ),
            ],
          ),

          if (currentList.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: currentList
                  .map(
                    (skill) => _SkillChip(
                      label: skill,
                      onRemove: () => onSkillRemoved(skill, tab == 0),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _SkillTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SkillTab(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? IthakiTheme.textPrimary
                  : IthakiTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 70,
            color: selected
                ? IthakiTheme.primaryPurple
                : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _SkillChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: IthakiTheme.accentPurpleLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: IthakiTheme.primaryPurple,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close,
                size: 14, color: IthakiTheme.primaryPurple),
          ),
        ],
      ),
    );
  }
}

class _WorkExperienceStep extends StatelessWidget {
  final bool noWorkExp;
  final ValueChanged<bool> onNoExpToggled;
  final TextEditingController jobTitleCtrl;
  final TextEditingController companyCtrl;
  final TextEditingController startCtrl;
  final TextEditingController endCtrl;
  final bool currentJob;
  final ValueChanged<bool> onCurrentJobToggled;
  final VoidCallback onChanged;

  const _WorkExperienceStep({
    required this.noWorkExp,
    required this.onNoExpToggled,
    required this.jobTitleCtrl,
    required this.companyCtrl,
    required this.startCtrl,
    required this.endCtrl,
    required this.currentJob,
    required this.onCurrentJobToggled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // No experience toggle
        _ToggleCard(
          label: 'I don\'t have work experience yet',
          value: noWorkExp,
          onChanged: onNoExpToggled,
        ),
        if (!noWorkExp) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                IthakiTextField(
                  label: 'Job Title',
                  hint: 'e.g. Software Developer',
                  controller: jobTitleCtrl,
                  onChanged: (_) => onChanged(),
                ),
                const SizedBox(height: 12),
                IthakiTextField(
                  label: 'Company',
                  hint: 'Company name',
                  controller: companyCtrl,
                  onChanged: (_) => onChanged(),
                ),
                const SizedBox(height: 12),
                IthakiTextField(
                  label: 'Start Date',
                  hint: 'MM-YYYY',
                  controller: startCtrl,
                  onChanged: (_) => onChanged(),
                ),
                const SizedBox(height: 12),
                _ToggleCard(
                  label: 'I currently work here',
                  value: currentJob,
                  onChanged: onCurrentJobToggled,
                ),
                if (!currentJob) ...[
                  const SizedBox(height: 12),
                  IthakiTextField(
                    label: 'End Date',
                    hint: 'MM-YYYY',
                    controller: endCtrl,
                    onChanged: (_) => onChanged(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _EducationStep extends StatelessWidget {
  final bool noEducation;
  final ValueChanged<bool> onNoEduToggled;
  final TextEditingController degreeCtrl;
  final TextEditingController institutionCtrl;
  final TextEditingController startCtrl;
  final TextEditingController endCtrl;
  final VoidCallback onChanged;

  const _EducationStep({
    required this.noEducation,
    required this.onNoEduToggled,
    required this.degreeCtrl,
    required this.institutionCtrl,
    required this.startCtrl,
    required this.endCtrl,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ToggleCard(
          label: 'I don\'t have education to add',
          value: noEducation,
          onChanged: onNoEduToggled,
        ),
        if (!noEducation) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                IthakiTextField(
                  label: 'Degree / Field of Study',
                  hint: 'e.g. Computer Science',
                  controller: degreeCtrl,
                  onChanged: (_) => onChanged(),
                ),
                const SizedBox(height: 12),
                IthakiTextField(
                  label: 'Institution',
                  hint: 'University or school name',
                  controller: institutionCtrl,
                  onChanged: (_) => onChanged(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: IthakiTextField(
                        label: 'Start',
                        hint: 'MM-YYYY',
                        controller: startCtrl,
                        onChanged: (_) => onChanged(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: IthakiTextField(
                        label: 'End',
                        hint: 'MM-YYYY',
                        controller: endCtrl,
                        onChanged: (_) => onChanged(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _LanguagesStep extends StatelessWidget {
  final TextEditingController langNameCtrl;
  final String langLevel;
  final List<_LangEntry> languages;
  final ValueChanged<String> onLevelChanged;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  const _LanguagesStep({
    required this.langNameCtrl,
    required this.langLevel,
    required this.languages,
    required this.onLevelChanged,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: IthakiTextField(
                  label: 'Language',
                  hint: 'e.g. English',
                  controller: langNameCtrl,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Level',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: IthakiTheme.borderLight),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: langLevel,
                          isExpanded: true,
                          style: const TextStyle(
                            fontSize: 14,
                            color: IthakiTheme.textPrimary,
                          ),
                          items: _levelOptions
                              .map((l) => DropdownMenuItem(
                                  value: l, child: Text(l)))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) onLevelChanged(v);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAdd,
              icon: const IthakiIcon('plus', size: 16),
              label: const Text('Add Language'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: IthakiTheme.primaryPurple),
                foregroundColor: IthakiTheme.primaryPurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (languages.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: IthakiTheme.borderLight),
            const SizedBox(height: 8),
            ...languages.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            e.value.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: IthakiTheme.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: IthakiTheme.accentPurpleLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            e.value.level,
                            style: const TextStyle(
                              fontSize: 12,
                              color: IthakiTheme.primaryPurple,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => onRemove(e.key),
                          child: const IthakiIcon('delete', size: 16,
                              color: IthakiTheme.softGraphite),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}

class _DocumentsStep extends StatelessWidget {
  final List<String> docNames;
  final VoidCallback onPick;
  final ValueChanged<int> onRemove;

  const _DocumentsStep({
    required this.docNames,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onPick,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                border: Border.all(
                    color: IthakiTheme.borderLight,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const IthakiIcon('upload-cloud', size: 36,
                      color: IthakiTheme.softGraphite),
                  const SizedBox(height: 10),
                  const Text(
                    'Tap to upload CV or documents',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: IthakiTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'PDF, DOC, DOCX, PNG, JPG · Max 5 MB',
                    style: TextStyle(
                        fontSize: 11, color: IthakiTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          if (docNames.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...docNames.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: IthakiTheme.accentPurpleLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: IthakiIcon('resume', size: 18,
                                color: IthakiTheme.primaryPurple),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            e.value,
                            style: const TextStyle(
                              fontSize: 13,
                              color: IthakiTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => onRemove(e.key),
                          child: const IthakiIcon('delete', size: 16,
                              color: IthakiTheme.softGraphite),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleCard({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: value ? IthakiTheme.accentPurpleLight : IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value ? IthakiTheme.primaryPurple : IthakiTheme.borderLight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: value
                      ? IthakiTheme.primaryPurple
                      : IthakiTheme.textPrimary,
                  fontWeight:
                      value ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: value
                        ? IthakiTheme.primaryPurple
                        : IthakiTheme.borderLight,
                    width: 2),
                color: value
                    ? IthakiTheme.primaryPurple
                    : Colors.transparent,
              ),
              child: value
                  ? const Icon(Icons.check,
                      size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data classes ─────────────────────────────────────────────────────────────

class _LangEntry {
  final String name;
  final String level;
  const _LangEntry({required this.name, required this.level});
}

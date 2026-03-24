import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/profile_provider.dart';

class EditCompetenciesScreen extends ConsumerStatefulWidget {
  const EditCompetenciesScreen({super.key});

  @override
  ConsumerState<EditCompetenciesScreen> createState() =>
      _EditCompetenciesScreenState();
}

class _EditCompetenciesScreenState
    extends ConsumerState<EditCompetenciesScreen> {
  String _computerSkill = '';
  String _drivingLicense = 'No';
  String _licenseCategory = '';
  bool _greekLicense = false;

  @override
  void initState() {
    super.initState();
    final comp = ref.read(profileProvider).competencies;
    _computerSkill = comp['computerSkills'] ?? '';
    _drivingLicense = comp['drivingLicense'] ?? 'No';
    _licenseCategory = comp['licenseCategory'] ?? '';
    _greekLicense = comp['greekLicense'] == 'true';
  }

  void _save() {
    ref.read(profileProvider.notifier).updateCompetencies({
      'computerSkills': _computerSkill,
      'drivingLicense': _drivingLicense,
      'licenseCategory': _licenseCategory,
      'greekLicense': _greekLicense.toString(),
    });
    context.pop();
  }

  Widget _optionTile(String option, String selected,
      ValueChanged<String> onSelect) {
    final isSelected = option == selected;
    return GestureDetector(
      onTap: () => onSelect(option),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? IthakiTheme.primaryPurple
                : IthakiTheme.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            option,
            style: TextStyle(
              fontSize: 14,
              color: isSelected
                  ? IthakiTheme.primaryPurple
                  : IthakiTheme.textPrimary,
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const computerOptions = ['Beginner', 'Basic', 'Advanced', 'Professional'];
    const licenseCategories = ['A', 'B', 'C', 'D', 'BE', 'CE'];

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        showBackButton: true,
        title: 'Edit Competencies',
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Computer Skills',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3,
                children: computerOptions
                    .map((o) => _optionTile(o, _computerSkill, (v) {
                          setState(() => _computerSkill = v);
                        }))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text('Driving License',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: ['Yes', 'No'].map((o) {
                  final isSelected = o == _drivingLicense;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: o == 'Yes' ? 8.0 : 0),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _drivingLicense = o),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? IthakiTheme.primaryPurple
                                  : IthakiTheme.borderLight,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              o,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? IthakiTheme.primaryPurple
                                    : IthakiTheme.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (_drivingLicense == 'Yes') ...[
                const SizedBox(height: 12),
                const Text('License Category',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                IthakiDropdown<String>(
                  label: '',
                  hint: 'Select category',
                  value: _licenseCategory.isEmpty ? null : _licenseCategory,
                  items: licenseCategories
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _licenseCategory = v ?? ''),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: _greekLicense,
                  onChanged: (v) =>
                      setState(() => _greekLicense = v ?? false),
                  title: const Text('Greek License'),
                  activeColor: IthakiTheme.primaryPurple,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
              const SizedBox(height: 24),
              IthakiButton('Save', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

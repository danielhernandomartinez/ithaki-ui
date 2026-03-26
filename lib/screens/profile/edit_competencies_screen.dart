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

  static const _computerOptions = ['Beginner', 'Basic', 'Advanced', 'Professional'];
  static const _licenseCategories = ['A', 'B', 'C', 'D', 'BE', 'CE'];

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

  Widget _optionTile(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0EAFF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? IthakiTheme.primaryPurple : IthakiTheme.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check, size: 16, color: IthakiTheme.primaryPurple),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? IthakiTheme.primaryPurple : IthakiTheme.textPrimary,
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
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: 'Edit Competencies'),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.viewPaddingOf(context).bottom + 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────
              const Text(
                'Edit Competencies',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.textPrimary),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select the skills that best represent your qualifications and professional expertise.',
                style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              // ── Computer Skills ──────────────────────────────────
              const Text('Computer Skills',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3.2,
                children: _computerOptions
                    .map((o) => _optionTile(
                          o,
                          _computerSkill == o,
                          () => setState(() => _computerSkill = o),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // ── Driving License ──────────────────────────────────
              const Text('Driving License',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 10),
              Row(
                children: ['Yes', 'No'].map((o) {
                  final isSelected = o == _drivingLicense;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: o == 'Yes' ? 8 : 0),
                      child: _optionTile(
                        o,
                        isSelected,
                        () => setState(() => _drivingLicense = o),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // ── Category (only when Yes) ─────────────────────────
              if (_drivingLicense == 'Yes') ...[
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('License Category',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: IthakiTheme.textPrimary)),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => SearchBottomSheet.show(
                        context,
                        'License Category',
                        _licenseCategories
                            .map((c) => SearchItem(
                                id: c, label: 'Category $c'))
                            .toList(),
                        (item) =>
                            setState(() => _licenseCategory = item.id),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: IthakiTheme.borderLight),
                        ),
                        child: Row(children: [
                          Expanded(
                            child: Text(
                              _licenseCategory.isEmpty
                                  ? 'Select category'
                                  : 'Category $_licenseCategory',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: _licenseCategory.isEmpty
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                                color: _licenseCategory.isEmpty
                                    ? IthakiTheme.softGraphite
                                    : IthakiTheme.textPrimary,
                              ),
                            ),
                          ),
                          const IthakiIcon('arrow-down',
                              size: 20,
                              color: IthakiTheme.softGraphite),
                        ]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                IthakiCheckbox(
                  value: _greekLicense,
                  onChanged: (v) => setState(() => _greekLicense = v),
                  child: const Text(
                    'I have Greek License',
                    style: TextStyle(fontSize: 14, color: IthakiTheme.textPrimary),
                  ),
                ),
              ],

              const SizedBox(height: 28),
              IthakiButton('Save', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

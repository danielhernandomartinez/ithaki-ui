import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'filter_sub_sheet.dart';
import 'location_filter_sheet.dart';
import 'salary_filter_sheet.dart';

const kFilterOptions = {
  'Location': ['Athens', 'Thessaloniki', 'Remote', 'Chalkida', 'Patras'],
  'Industry': ['IT & Web Development', 'Design & Creative', 'Sales', 'Marketing', 'Customer Service', 'Logistics', 'Finance', 'Healthcare'],
  'Skills': ['Flutter', 'React', 'Python', 'Figma', 'SQL', 'Node.js', 'Swift', 'Kotlin'],
  'Job Type': ['Full-Time', 'Part-Time', 'Contract', 'Freelance', 'Internship'],
  'Workplace': ['On-site', 'Remote', 'Hybrid'],
  'Experience Level': ['Entry', 'Junior', 'Mid-level', 'Senior', 'Lead'],
  'Salary': ['< 1 000 €', '1 000 – 2 000 €', '2 000 – 3 500 €', '3 500 – 5 000 €', '> 5 000 €'],
  'Travel': ['No travel', 'Occasional', 'Frequent', 'International'],
};

class FiltersSheet extends StatefulWidget {
  final Map<String, Set<String>> filters;
  final void Function(Map<String, Set<String>>) onApply;

  const FiltersSheet({super.key, required this.filters, required this.onApply});

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  late Map<String, Set<String>> _local;

  @override
  void initState() {
    super.initState();
    _local = {for (final e in widget.filters.entries) e.key: Set.from(e.value)};
  }

  void _openSubSheet(String filterName) {
    if (filterName == 'Location') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => LocationFilterSheet(
          selected: Set.from(_local['Location'] ?? {}),
          onConfirm: (selected) =>
              setState(() => _local['Location'] = selected),
        ),
      );
      return;
    }
    if (filterName == 'Salary') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => SalaryFilterSheet(
          selected: Set.from(_local['Salary'] ?? {}),
          onConfirm: (selected) =>
              setState(() => _local['Salary'] = selected),
        ),
      );
      return;
    }
    final options = kFilterOptions[filterName] ?? [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSubSheet(
        title: filterName,
        options: options,
        selected: Set.from(_local[filterName] ?? {}),
        onConfirm: (selected) => setState(() => _local[filterName] = selected),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filters',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary)),
                IconButton(
                  icon: const Icon(Icons.close,
                      size: 22, color: IthakiTheme.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // ── Filter rows ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: kFilterOptions.keys.map((name) {
                final selected = _local[name] ?? {};
                final hasSelection = selected.isNotEmpty;
                String valueText = selected.join('; ');
                if (name == 'Salary' && selected.isNotEmpty) {
                  final parts = selected.first.split('-');
                  if (parts.length == 2) {
                    String fmtNum(String n) {
                      final s = (int.tryParse(n) ?? 0).toString();
                      final buf = StringBuffer();
                      for (int i = 0; i < s.length; i++) {
                        if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
                        buf.write(s[i]);
                      }
                      return buf.toString();
                    }
                    valueText = '${fmtNum(parts[0])} – ${fmtNum(parts[1])} €';
                  }
                }
                return GestureDetector(
                  onTap: () => _openSubSheet(name),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: hasSelection
                          ? const Color(0xFFF6F2FE)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: hasSelection
                              ? const Color(0xFFDDD5F8)
                              : const Color(0xFFE0E0E0)),
                    ),
                    child: Row(children: [
                      Text(name,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: hasSelection
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: IthakiTheme.textPrimary)),
                      if (hasSelection) ...[
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            valueText,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14,
                                color: IthakiTheme.textSecondary),
                          ),
                        ),
                      ] else
                        const Spacer(),
                      const Icon(Icons.chevron_right,
                          color: IthakiTheme.softGraphite, size: 20),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // ── Buttons ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(
                      () => _local.updateAll((_, __) => {})),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Reset Filters'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: IthakiTheme.borderLight),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    foregroundColor: IthakiTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_local);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IthakiTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Apply Filters',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../utils/number_utils.dart';

class SalaryFilterSheet extends StatefulWidget {
  final Set<String> selected;
  final void Function(Set<String>) onConfirm;

  const SalaryFilterSheet(
      {super.key, required this.selected, required this.onConfirm});

  @override
  State<SalaryFilterSheet> createState() => _SalaryFilterSheetState();
}

class _SalaryFilterSheetState extends State<SalaryFilterSheet> {
  static const double _min = 0;
  static const double _max = 20000;

  late RangeValues _range;

  @override
  void initState() {
    super.initState();
    if (widget.selected.isNotEmpty) {
      final parts = widget.selected.first.split('-');
      if (parts.length == 2) {
        final from = double.tryParse(parts[0]);
        final to = double.tryParse(parts[1]);
        if (from != null && to != null) {
          _range = RangeValues(from, to);
          return;
        }
      }
    }
    _range = const RangeValues(_min, _max);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 16, 20, 0),
            child: Row(children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,
                    size: 22, color: IthakiTheme.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
              const Text('Salary',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
            ]),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 24),

          // ── From / Till fields ────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('From',
                        style: TextStyle(
                            fontSize: 12, color: IthakiTheme.textSecondary)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      decoration: BoxDecoration(
                        border: Border.all(color: IthakiTheme.borderLight),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatNumber(_range.start.toInt(), separator: ' '),
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: IthakiTheme.textPrimary)),
                          const Text('€',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: IthakiTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Till',
                        style: TextStyle(
                            fontSize: 12, color: IthakiTheme.textSecondary)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      decoration: BoxDecoration(
                        border: Border.all(color: IthakiTheme.borderLight),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatNumber(_range.end.toInt(), separator: ' '),
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: IthakiTheme.textPrimary)),
                          const Text('€',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: IthakiTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          // ── Range slider ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: IthakiTheme.primaryPurple,
                inactiveTrackColor: const Color(0xFFE0D5F8),
                thumbColor: IthakiTheme.primaryPurple,
                overlayColor:
                    IthakiTheme.primaryPurple.withValues(alpha: 0.12),
                trackHeight: 4,
              ),
              child: RangeSlider(
                values: _range,
                min: _min,
                max: _max,
                divisions: 40,
                onChanged: (v) => setState(() => _range = v),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Buttons ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(
                      () => _range = const RangeValues(_min, _max)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: IthakiTheme.borderLight),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    foregroundColor: IthakiTheme.textPrimary,
                  ),
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final isDefault =
                        _range.start == _min && _range.end == _max;
                    widget.onConfirm(isDefault
                        ? {}
                        : {'${_range.start.toInt()}-${_range.end.toInt()}'});
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
                  child: const Text('Apply Filter',
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

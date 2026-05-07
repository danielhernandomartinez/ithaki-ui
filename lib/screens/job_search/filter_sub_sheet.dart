import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../l10n/app_localizations.dart';

class FilterSubSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final Set<String> selected;
  final void Function(Set<String>) onConfirm;

  const FilterSubSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onConfirm,
  });

  @override
  State<FilterSubSheet> createState() => _FilterSubSheetState();
}

class _FilterSubSheetState extends State<FilterSubSheet> {
  late Set<String> _selected;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selected);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final filtered = _query.isEmpty
        ? widget.options
        : widget.options
            .where((o) => o.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
      decoration: const BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding + 16),
      child: Column(
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
              Text(widget.title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
            ]),
          ),
          const SizedBox(height: 12),

          // ── Search field ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l.searchHint,
                hintStyle: const TextStyle(
                    color: IthakiTheme.softGraphite, fontSize: 14),
                prefixIcon:
                    const Icon(Icons.search, color: IthakiTheme.softGraphite),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: IthakiTheme.borderLight)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: IthakiTheme.borderLight)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                        color: IthakiTheme.primaryPurple, width: 1.5)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // ── Checkbox list ─────────────────────────────────
          Expanded(
            child: ListView(
              children: [
                CheckboxListTile(
                  value: _selected.isEmpty,
                  onChanged: (_) => setState(() => _selected.clear()),
                  title: Text(l.filterAllLabel,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: IthakiTheme.textPrimary)),
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: IthakiTheme.primaryPurple,
                  checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                ...filtered.map((option) {
                  final isChosen = _selected.contains(option);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CheckboxListTile(
                        value: isChosen,
                        onChanged: (_) => setState(() => isChosen
                            ? _selected.remove(option)
                            : _selected.add(option)),
                        title: Text(option,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: isChosen
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: IthakiTheme.textPrimary)),
                        controlAffinity: ListTileControlAffinity.trailing,
                        activeColor: IthakiTheme.primaryPurple,
                        checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    ],
                  );
                }),
              ],
            ),
          ),

          // ── Buttons ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _selected.clear()),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: IthakiTheme.borderLight),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    foregroundColor: IthakiTheme.textPrimary,
                  ),
                  child: Text(l.filterClear),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onConfirm(_selected);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IthakiTheme.primaryPurple,
                    foregroundColor: IthakiTheme.backgroundWhite,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Text(l.applyFilter,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

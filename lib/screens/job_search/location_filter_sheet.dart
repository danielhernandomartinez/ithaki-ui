import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../data/countries.dart';
import '../../services/city_search_service.dart';

class LocationFilterSheet extends ConsumerStatefulWidget {
  final Set<String> selected;
  final void Function(Set<String>) onConfirm;

  const LocationFilterSheet(
      {super.key, required this.selected, required this.onConfirm});

  @override
  ConsumerState<LocationFilterSheet> createState() =>
      _LocationFilterSheetState();
}

class _LocationFilterSheetState extends ConsumerState<LocationFilterSheet> {
  SearchItem? _country;
  final _searchCtrl = TextEditingController();
  Timer? _debounce;
  List<CityResult> _results = [];
  bool _loading = false;
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selected);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _pickCountry() {
    SearchBottomSheet.show(context, 'Select Country', allCountries,
        (item) => setState(() {
              _country = item;
              _searchCtrl.clear();
              _results = [];
            }));
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < 2) {
      setState(() => _results = []);
      return;
    }
    _debounce = Timer(
        const Duration(milliseconds: 400), () => _search(value.trim()));
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    final results = await ref
        .read(citySearchServiceProvider)
        .search(query, countryCode: _country?.id);
    if (mounted) setState(() { _results = results; _loading = false; });
  }

  void _toggle(String city) => setState(() =>
      _selected.contains(city) ? _selected.remove(city) : _selected.add(city));

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
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
              const Text('Location',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
            ]),
          ),
          const SizedBox(height: 12),

          // ── Country picker ────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: _pickCountry,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: _country != null
                          ? IthakiTheme.primaryPurple
                          : IthakiTheme.borderLight),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(children: [
                  if (_country != null) ...[
                    IthakiFlag(_country!.id, width: 22, height: 16),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      _country?.label ?? 'Select a country first',
                      style: TextStyle(
                        fontSize: 14,
                        color: _country != null
                            ? IthakiTheme.textPrimary
                            : IthakiTheme.softGraphite,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down,
                      color: IthakiTheme.softGraphite),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── City search ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchCtrl,
              enabled: _country != null,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: _country != null
                    ? 'Search city in ${_country!.label}…'
                    : 'Search for Location',
                hintStyle: const TextStyle(
                    color: IthakiTheme.softGraphite, fontSize: 14),
                prefixIcon:
                    const Icon(Icons.search, color: IthakiTheme.softGraphite),
                suffixIcon: _loading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2)))
                    : null,
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
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: Color(0xFFEEEEEE))),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: _country == null,
                fillColor: const Color(0xFFF8F8F8),
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
                  title: const Text('All',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: IthakiTheme.textPrimary)),
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: IthakiTheme.primaryPurple,
                  checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                ..._selected
                    .where((city) => !_results.any((r) => r.city == city))
                    .map((city) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CheckboxListTile(
                              value: true,
                              onChanged: (_) => _toggle(city),
                              title: Text(city,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: IthakiTheme.textPrimary)),
                              controlAffinity:
                                  ListTileControlAffinity.trailing,
                              activeColor: IthakiTheme.primaryPurple,
                              checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            const Divider(
                                height: 1, color: Color(0xFFF0F0F0)),
                          ],
                        )),
                ..._results.map((r) {
                  final isChosen = _selected.contains(r.city);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CheckboxListTile(
                        value: isChosen,
                        onChanged: (_) => _toggle(r.city),
                        title: Text(r.city,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: isChosen
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: IthakiTheme.textPrimary)),
                        subtitle: r.country.isNotEmpty
                            ? Text(r.country,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: IthakiTheme.textSecondary))
                            : null,
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
                  child: const Text('Clear'),
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

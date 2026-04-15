import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../repositories/city_search_repository.dart';

class CitySearchBottomSheet extends ConsumerStatefulWidget {
  final void Function(String city) onSelected;

  const CitySearchBottomSheet({super.key, required this.onSelected});

  static void show(BuildContext context, void Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CitySearchBottomSheet(onSelected: onSelected),
    );
  }

  @override
  ConsumerState<CitySearchBottomSheet> createState() => _CitySearchBottomSheetState();
}

class _CitySearchBottomSheetState extends ConsumerState<CitySearchBottomSheet> {
  final _ctrl = TextEditingController();
  Timer? _debounce;
  List<CityResult> _results = [];
  bool _loading = false;
  String _lastQuery = '';

  @override
  void dispose() {
    _ctrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final trimmed = value.trim();
    if (trimmed == _lastQuery) return;
    if (trimmed.length < 2) {
      _lastQuery = '';
      setState(() => _results = []);
      return;
    }
    _lastQuery = trimmed;
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(trimmed));
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    final repo = ref.read(citySearchRepositoryProvider);
    final results = await repo.search(query);
    if (!mounted || _lastQuery != query) return;
    setState(() { _results = results; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle ──────────────────────────────────────────
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: IthakiTheme.placeholderBg,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Title ───────────────────────────────────────────
          const Text('Search City',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 12),

          // ── Search field ─────────────────────────────────────
          TextField(
            controller: _ctrl,
            autofocus: true,
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: 'Type a city name...',
              hintStyle: const TextStyle(
                  color: IthakiTheme.softGraphite, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: IthakiTheme.softGraphite),
              suffixIcon: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)))
                  : null,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: IthakiTheme.borderLight)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: IthakiTheme.borderLight)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: IthakiTheme.primaryPurple, width: 1.5)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 8),

          // ── Results ──────────────────────────────────────────
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.4,
            ),
            child: _results.isEmpty && !_loading
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        _ctrl.text.length < 2
                            ? 'Type at least 2 characters'
                            : 'No cities found',
                        style: const TextStyle(
                            fontSize: 14, color: IthakiTheme.textSecondary),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: _results.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    itemBuilder: (_, i) {
                      final r = _results[i];
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        leading: const Icon(Icons.location_on_outlined,
                            color: IthakiTheme.softGraphite, size: 20),
                        title: Text(r.city,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: IthakiTheme.textPrimary)),
                        subtitle: Text(r.country,
                            style: const TextStyle(
                                fontSize: 12,
                                color: IthakiTheme.textSecondary)),
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onSelected(r.display);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

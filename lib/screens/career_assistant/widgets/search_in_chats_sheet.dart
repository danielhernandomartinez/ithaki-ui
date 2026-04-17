import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../models/chat_mock_data.dart';
import 'chat_history_sheet.dart';

class SearchInChatsSheet extends StatefulWidget {
  const SearchInChatsSheet({super.key});

  @override
  State<SearchInChatsSheet> createState() => _SearchInChatsSheetState();
}

class _SearchInChatsSheetState extends State<SearchInChatsSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  static const _allItems = [...kHistoryToday, ...kHistoryLast7];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _results {
    if (_query.isEmpty) return [];
    return _allItems.where((i) => i.toLowerCase().contains(_query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final results = _results;

    return Container(
      decoration: const BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: IthakiTheme.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Search in Chats',
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const IthakiIcon('delete', size: 22, color: IthakiTheme.softGraphite),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (v) => setState(() => _query = v.toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search messages...',
              hintStyle: const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12, right: 8),
                child: IthakiIcon('search', size: 18, color: IthakiTheme.softGraphite),
              ),
              prefixIconConstraints: const BoxConstraints(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: IthakiTheme.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: IthakiTheme.borderLight),
              ),
            ),
          ),
          if (results.isNotEmpty) ...[
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: results.map((item) => ChatHistoryItem(label: item)).toList(),
                ),
              ),
            ),
          ],
          if (_query.isNotEmpty && results.isEmpty) ...[
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'No results found',
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  color: IthakiTheme.textSecondary,
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

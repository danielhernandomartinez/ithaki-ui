import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../models/chat_mock_data.dart';

// ---------------------------------------------------------------------------
// Chat History bottom sheet
// ---------------------------------------------------------------------------

class ChatHistorySheet extends StatefulWidget {
  const ChatHistorySheet({super.key});

  @override
  State<ChatHistorySheet> createState() => _ChatHistorySheetState();
}

class _ChatHistorySheetState extends State<ChatHistorySheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _filtered(List<String> items) {
    if (_query.isEmpty) return items;
    return items.where((i) => i.toLowerCase().contains(_query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final todayItems = _filtered(kHistoryToday);
    final lastItems = _filtered(kHistoryLast7);

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
              Expanded(
                child: Text(
                  l.chatHistory,
                  style: const TextStyle(
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
          const SizedBox(height: 8),
          Text(
            l.chatHistorySubtitle,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 13,
              color: IthakiTheme.softGraphite,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v.toLowerCase()),
            decoration: InputDecoration(
              hintText: l.chatHistorySearchHint,
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
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (todayItems.isNotEmpty) ...[
                    Text(
                      l.chatHistoryToday,
                      style: const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    ...todayItems.map((item) => ChatHistoryItem(label: item)),
                    const SizedBox(height: 12),
                  ],
                  if (lastItems.isNotEmpty) ...[
                    Text(
                      l.chatHistoryLast7Days,
                      style: const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    ...lastItems.map((item) => ChatHistoryItem(label: item)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single history row
// ---------------------------------------------------------------------------

class ChatHistoryItem extends StatelessWidget {
  final String label;
  const ChatHistoryItem({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const IthakiIcon('applications', size: 18, color: IthakiTheme.softGraphite),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

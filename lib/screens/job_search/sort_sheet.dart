import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class SortSheet extends StatelessWidget {
  final String current;
  final void Function(String) onSelect;

  const SortSheet({super.key, required this.current, required this.onSelect});

  static const options = [
    'Most relevant',
    'Salary: High to Low',
    'Salary: Low to High',
    'Date: Recent',
    'Date: Latest',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sorting',
                    style: TextStyle(
                        fontSize: 18,
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
          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // ── Options ───────────────────────────────────────
          ...options.map((option) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    title: Text(option,
                        style: TextStyle(
                            fontSize: 15,
                            color: option == current
                                ? IthakiTheme.primaryPurple
                                : IthakiTheme.textPrimary)),
                    trailing: option == current
                        ? const Icon(Icons.check,
                            color: IthakiTheme.primaryPurple, size: 20)
                        : null,
                    onTap: () {
                      onSelect(option);
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                ],
              )),
        ],
      ),
    );
  }
}

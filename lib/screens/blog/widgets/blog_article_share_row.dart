import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';

class BlogArticleShareRow extends StatelessWidget {
  const BlogArticleShareRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.shareLabel,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
          ),
        ),
        const SizedBox(width: 12),
        for (final icon in ['linkedin', 'facebook', 'x']) ...[
          _ShareIcon(icon: icon),
          const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _ShareIcon extends StatelessWidget {
  final String icon;
  const _ShareIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {/* share stub */},
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: IthakiTheme.borderLight),
        ),
        alignment: Alignment.center,
        child: IthakiIcon(icon, size: 18, color: IthakiTheme.softGraphite),
      ),
    );
  }
}

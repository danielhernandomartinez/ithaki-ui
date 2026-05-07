import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../l10n/app_localizations.dart';

class UploadUrlTab extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const UploadUrlTab({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.documentUrlDescription,
          style:
              const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        _BulletText(l.documentUrlMustBeActive),
        _BulletText(l.documentUrlSupportedFormats),
        _BulletText(l.documentUrlCommonServices),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: l.documentLinkHint,
            hintStyle:
                const TextStyle(color: IthakiTheme.softGraphite, fontSize: 14),
            prefixIcon: const Icon(Icons.link, color: IthakiTheme.softGraphite),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: IthakiTheme.primaryPurple)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _BulletText extends StatelessWidget {
  final String text;
  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(color: IthakiTheme.textSecondary, fontSize: 13)),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      color: IthakiTheme.textSecondary, fontSize: 13))),
        ],
      ),
    );
  }
}

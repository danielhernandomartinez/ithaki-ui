import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/profile_models.dart';

class CvFileCard extends StatelessWidget {
  const CvFileCard({
    super.key,
    required this.file,
    required this.isPublished,
    this.onDelete,
  });

  final UploadedFile file;
  final bool isPublished;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: IthakiTheme.softGray.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'PDF',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.softGraphite,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      file.size,
                      style: const TextStyle(
                        fontSize: 13,
                        color: IthakiTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: IthakiOutlineButton(
                  l.open,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.openingFile(file.name))),
                    );
                  },
                  borderRadius: 22,
                ),
              ),
              if (!isPublished && onDelete != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: IthakiOutlineButton(
                    l.delete,
                    icon: const IthakiIcon('delete', size: 18),
                    onPressed: onDelete,
                    borderRadius: 22,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

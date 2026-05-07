import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../l10n/app_localizations.dart';
import '../models/profile_models.dart';
import 'dotted_border_box.dart';

class UploadFileTab extends StatelessWidget {
  final List<UploadedFile> files;
  final VoidCallback onPickFiles;
  final ValueChanged<UploadedFile> onRemoveFile;

  const UploadFileTab({
    super.key,
    required this.files,
    required this.onPickFiles,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    if (files.isEmpty) {
      return DottedBorderBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_rounded,
                size: 32, color: IthakiTheme.softGraphite),
            const SizedBox(height: 8),
            Text(
              l.uploadFileInstructions,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, color: IthakiTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            IthakiButton(l.uploadFile, onPressed: onPickFiles),
          ],
        ),
      );
    }
    return ListView(
      children: [
        ...files.map((f) => _FileRow(file: f, onRemove: () => onRemoveFile(f))),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: onPickFiles,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            foregroundColor: IthakiTheme.textPrimary,
            textStyle: const TextStyle(fontSize: 14),
          ),
          child: Text(l.uploadMore),
        ),
      ],
    );
  }
}

class _FileRow extends StatelessWidget {
  final UploadedFile file;
  final VoidCallback onRemove;

  const _FileRow({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              file.name.contains('.')
                  ? file.name.split('.').last.toUpperCase()
                  : l.fileFallbackLabel,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.softGraphite),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: IthakiTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(
                  file.isComplete
                      ? '${file.size} | ${l.fileComplete}'
                      : '${file.size} | ${l.fileUploading}',
                  style: const TextStyle(
                      fontSize: 12, color: IthakiTheme.textSecondary),
                ),
                if (!file.isComplete) ...[
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: file.uploadProgress,
                    color: IthakiTheme.primaryPurple,
                    backgroundColor: Colors.grey.shade200,
                    minHeight: 3,
                  ),
                ],
              ],
            ),
          ),
          if (file.isComplete)
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  size: 18, color: IthakiTheme.softGraphite),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

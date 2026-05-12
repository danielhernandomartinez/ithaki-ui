import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/profile_provider.dart';
import '../../../repositories/profile_repository.dart';
import '../../../widgets/profile_empty_state_card.dart';
import '../../../widgets/upload_files_sheet.dart';

class ProfileFilesTab extends ConsumerWidget {
  const ProfileFilesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final files = ref.watch(profileFilesProvider).value ?? const [];
    if (files.isEmpty) {
      return ProfileEmptyStateCard(
        title: l.profileMyFilesTitle,
        description: l.profileFilesDescription,
        buttonLabel: l.uploadFile,
        buttonIcon: const IthakiIcon('upload-cloud', size: 16),
        onPressed: () => _openUpload(context, ref),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.profileMyFilesTitle,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary)),
        const SizedBox(height: 16),
        ...files.asMap().entries.map((entry) {
          final i = entry.key;
          final f = entry.value;
          final ext = f.name.contains('.')
              ? f.name.split('.').last.toUpperCase()
              : 'FILE';
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(ext,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: IthakiTheme.softGraphite)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f.name,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: IthakiTheme.textPrimary)),
                      Text(f.size,
                          style: const TextStyle(
                              fontSize: 12, color: IthakiTheme.textSecondary)),
                    ]),
              ),
              TextButton(
                onPressed: () => _openFile(context, ref, f),
                child: Text(l.open,
                    style: const TextStyle(color: IthakiTheme.primaryPurple)),
              ),
              TextButton(
                onPressed: () =>
                    ref.read(profileFilesProvider.notifier).delete(i),
                child:
                    Text(l.delete, style: const TextStyle(color: Colors.red)),
              ),
            ]),
          );
        }),
        const SizedBox(height: 4),
        IthakiOutlineButton(
          l.uploadFile,
          icon: const IthakiIcon('upload-cloud', size: 16),
          onPressed: () => _openUpload(context, ref),
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ]),
    );
  }

  void _openUpload(BuildContext context, WidgetRef ref) =>
      UploadFilesSheet.show(context, onContinue: (files) {
        ref.read(profileFilesProvider.notifier).addAll(files);
      });

  Future<void> _openFile(
      BuildContext context, WidgetRef ref, UploadedFile file) async {
    final l = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final bytes =
          await ref.read(profileRepositoryProvider).downloadFile(file);
      final dir = await getTemporaryDirectory();
      final tempFile = File('${dir.path}/${file.id ?? 'f'}_${file.name}');
      await tempFile.writeAsBytes(bytes, flush: true);

      if (!context.mounted) return;
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();

      final result = await OpenFilex.open(tempFile.path);
      if (!context.mounted) return;
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.couldNotOpenFile(file.name))),
        );
      }
    } catch (_) {
      if (!context.mounted) return;
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotOpenFile(file.name))),
      );
    }
  }
}

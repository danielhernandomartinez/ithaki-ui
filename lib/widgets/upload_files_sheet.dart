// lib/widgets/upload_files_sheet.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../models/profile_models.dart';
import 'upload_file_tab.dart';
import 'upload_url_tab.dart';

/// Two-tab bottom sheet: "Upload File" and "Upload via URL".
/// Simulates upload progress with mock data.
class UploadFilesSheet extends StatefulWidget {
  final void Function(List<UploadedFile> files) onContinue;

  const UploadFilesSheet({super.key, required this.onContinue});

  static void show(BuildContext context,
      {required void Function(List<UploadedFile>) onContinue}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UploadFilesSheet(onContinue: onContinue),
    );
  }

  @override
  State<UploadFilesSheet> createState() => _UploadFilesSheetState();
}

class _UploadFilesSheetState extends State<UploadFilesSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  final List<UploadedFile> _files = [];
  final _urlCtrl = TextEditingController();
  UploadedFile? _urlFile;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'],
    );
    if (result == null || !mounted) return;
    setState(() {
      for (final file in result.files) {
        final sizeKb = file.size / 1024;
        final sizeStr = sizeKb >= 1024
            ? '${(sizeKb / 1024).toStringAsFixed(1)} MB'
            : '${sizeKb.toStringAsFixed(0)} KB';
        _files.add(UploadedFile(
          name: file.name,
          size: sizeStr,
          uploadProgress: 1.0,
        ));
      }
    });
  }

  bool get _allComplete =>
      _files.isNotEmpty && _files.every((f) => f.isComplete);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final tabHeight = mq.size.height * 0.38;
    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: mq.size.height * 0.88),
        child: Container(
          decoration: const BoxDecoration(
            color: IthakiTheme.backgroundWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Upload Files',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: IthakiTheme.textPrimary)),
                  IconButton(
                    icon: const Icon(Icons.close, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TabBar(
                controller: _tabCtrl,
                labelColor: IthakiTheme.primaryPurple,
                unselectedLabelColor: IthakiTheme.textSecondary,
                indicatorColor: IthakiTheme.primaryPurple,
                tabs: const [
                  Tab(text: 'Upload File'),
                  Tab(text: 'Upload via URL'),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: tabHeight,
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [
                    UploadFileTab(
                      files: _files,
                      onPickFiles: _pickFiles,
                      onRemoveFile: (f) => setState(() => _files.remove(f)),
                    ),
                    UploadUrlTab(
                      controller: _urlCtrl,
                      onChanged: (v) => setState(() {
                        _urlFile = v.trim().isNotEmpty
                            ? UploadedFile(
                                name: v.trim(),
                                size: 'URL',
                                uploadProgress: 1.0)
                            : null;
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: IthakiButton(
                  'Continue',
                  onPressed: _allComplete || _urlFile != null
                      ? () {
                          final result = [..._files];
                          if (_urlFile != null) result.add(_urlFile!);
                          widget.onContinue(result);
                          Navigator.of(context).pop();
                        }
                      : null,
                ),
              ),
              SizedBox(height: mq.padding.bottom + 20),
            ],
          ),
        ),
      ),
    );
  }
}

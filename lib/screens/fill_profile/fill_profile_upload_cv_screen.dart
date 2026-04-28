import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/fill_profile_provider.dart';
import '../../routes.dart';

enum _UploadState { idle, uploading, uploaded, generating }

class FillProfileUploadCvScreen extends ConsumerStatefulWidget {
  const FillProfileUploadCvScreen({super.key});

  @override
  ConsumerState<FillProfileUploadCvScreen> createState() =>
      _FillProfileUploadCvScreenState();
}

class _FillProfileUploadCvScreenState
    extends ConsumerState<FillProfileUploadCvScreen> {
  int _tab = 0; // 0 = file, 1 = URL
  _UploadState _uploadState = _UploadState.idle;
  String? _fileName;
  final _urlCtrl = TextEditingController();
  double _progress = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _urlCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result == null || result.files.isEmpty) return;
    setState(() {
      _fileName = result.files.first.name;
      _uploadState = _UploadState.idle;
    });
  }

  void _startUpload() {
    setState(() {
      _uploadState = _UploadState.uploading;
      _progress = 0;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      final next = _progress + 0.04;
      if (next >= 1.0) {
        t.cancel();
        setState(() {
          _progress = 1.0;
          _uploadState = _UploadState.uploaded;
        });
      } else {
        setState(() => _progress = next);
      }
    });
  }

  Future<void> _generateCv() async {
    setState(() => _uploadState = _UploadState.generating);
    // Simulate CV generation
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    await ref.read(fillProfileDoneProvider.notifier).markDone();
    if (mounted) context.go(Routes.profile);
  }

  bool get _canUpload =>
      (_tab == 0 && _fileName != null) ||
      (_tab == 1 && _urlCtrl.text.trim().isNotEmpty);

  @override
  Widget build(BuildContext context) {
    if (_uploadState == _UploadState.generating) {
      return _GeneratingScreen();
    }

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        showBackButton: true,
        title: 'Upload CV',
        onMenuPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.viewPaddingOf(context).bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload your CV',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'We\'ll extract your information and fill your profile automatically.',
              style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
            ),
            const SizedBox(height: 24),

            // Tabs
            Row(
              children: [
                _TabButton(
                  label: 'Upload File',
                  selected: _tab == 0,
                  onTap: () => setState(() => _tab = 0),
                ),
                const SizedBox(width: 24),
                _TabButton(
                  label: 'Upload via URL',
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (_tab == 0) _buildFileTab() else _buildUrlTab(),

            const SizedBox(height: 24),
            IthakiButton(
              _uploadState == _UploadState.uploaded ? 'Generate Profile' : 'Upload',
              onPressed: _canUpload
                  ? () {
                      if (_uploadState == _UploadState.uploaded) {
                        _generateCv();
                      } else {
                        _startUpload();
                      }
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileTab() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        children: [
          if (_uploadState == _UploadState.idle || _fileName == null) ...[
            const IthakiIcon('upload-cloud', size: 40, color: IthakiTheme.softGraphite),
            const SizedBox(height: 12),
            const Text(
              'Drag and drop your CV here\nor tap to browse',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Supported: PDF, DOC, DOCX · Max 5 MB',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: IthakiTheme.lightGraphite),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickFile,
              icon: const IthakiIcon('upload-cloud', size: 16),
              label: const Text('Browse Files'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: IthakiTheme.softGraphite),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                foregroundColor: IthakiTheme.textPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: IthakiTheme.accentPurpleLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: IthakiIcon('resume', size: 20,
                        color: IthakiTheme.primaryPurple),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fileName!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: IthakiTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_uploadState == _UploadState.uploading) ...[
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: IthakiTheme.borderLight,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              IthakiTheme.primaryPurple),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(_progress * 100).round()}%',
                          style: const TextStyle(
                              fontSize: 11,
                              color: IthakiTheme.textSecondary),
                        ),
                      ] else if (_uploadState == _UploadState.uploaded) ...[
                        const SizedBox(height: 4),
                        const Text(
                          'Uploaded successfully',
                          style: TextStyle(
                              fontSize: 12,
                              color: IthakiTheme.matchGreen),
                        ),
                      ],
                    ],
                  ),
                ),
                if (_uploadState == _UploadState.idle ||
                    _uploadState == _UploadState.uploaded)
                  GestureDetector(
                    onTap: () => setState(() {
                      _fileName = null;
                      _uploadState = _UploadState.idle;
                    }),
                    child: const IthakiIcon('delete', size: 18,
                        color: IthakiTheme.softGraphite),
                  ),
              ],
            ),
            if (_uploadState == _UploadState.idle && _fileName != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: _pickFile,
                child: const Text('Choose a different file'),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildUrlTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Paste the URL to your CV',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _urlCtrl,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'https://...',
              hintStyle: const TextStyle(
                  color: IthakiTheme.softGraphite, fontSize: 14),
              prefixIcon: const Icon(Icons.link, color: IthakiTheme.softGraphite),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: IthakiTheme.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                    color: IthakiTheme.primaryPurple, width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? IthakiTheme.textPrimary
                  : IthakiTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 80,
            decoration: BoxDecoration(
              color: selected
                  ? IthakiTheme.primaryPurple
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneratingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: IthakiTheme.primaryPurple),
            SizedBox(height: 24),
            Text(
              'Generating your profile...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We\'re extracting your information.\nThis takes just a moment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: IthakiTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

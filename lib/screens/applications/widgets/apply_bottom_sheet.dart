import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/applications_provider.dart';

enum _CvOption { ithaki, upload }

class ApplyBottomSheet extends ConsumerStatefulWidget {
  final String jobId;
  const ApplyBottomSheet({super.key, required this.jobId});

  @override
  ConsumerState<ApplyBottomSheet> createState() => _ApplyBottomSheetState();
}

class _ApplyBottomSheetState extends ConsumerState<ApplyBottomSheet> {
  _CvOption _cvOption = _CvOption.ithaki;
  String? _pickedFilePath;
  String? _pickedFileName;
  final _coverLetterCtrl = TextEditingController();
  DateTime? _availabilityDate;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _coverLetterCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.path == null) return;
    setState(() {
      _pickedFilePath = file.path;
      _pickedFileName = file.name;
      _error = null;
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _availabilityDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => _availabilityDate = picked);
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (_cvOption == _CvOption.upload && _pickedFilePath == null) {
      setState(() => _error = AppLocalizations.of(context)!.applySelectCvFile);
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    debugPrint('[Apply] Starting application for jobId=${widget.jobId}');
    debugPrint('[Apply] CV option: ${_cvOption.name}');

    try {
      final repo = ref.read(applicationsRepositoryProvider);

      String? cvFilePath;
      if (_cvOption == _CvOption.upload && _pickedFilePath != null) {
        debugPrint('[Apply] Uploading CV: $_pickedFilePath');
        cvFilePath = await repo.uploadApplicationCv(_pickedFilePath!);
        debugPrint('[Apply] CV uploaded → s3 key: $cvFilePath');
      }

      final availability = _availabilityDate != null
          ? '${_availabilityDate!.year}-'
              '${_availabilityDate!.month.toString().padLeft(2, '0')}-'
              '${_availabilityDate!.day.toString().padLeft(2, '0')}'
          : null;

      debugPrint('[Apply] Submitting application: '
          'jobId=${widget.jobId}, '
          'cvFilePath=$cvFilePath, '
          'availabilityPeriod=$availability, '
          'coverLetter=${_coverLetterCtrl.text.trim().isEmpty ? "(none)" : "(present)"}');

      await repo.submitApplication(
        jobId: widget.jobId,
        coverLetter: _coverLetterCtrl.text.trim().isEmpty
            ? null
            : _coverLetterCtrl.text.trim(),
        availabilityPeriod: availability,
        cvFilePath: cvFilePath,
      );

      debugPrint('[Apply] Application submitted successfully');
      ref.invalidate(applicationsProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.applySubmitSuccess),
            backgroundColor: IthakiTheme.matchGreen,
          ),
        );
      }
    } catch (e) {
      debugPrint('[Apply] ERROR: $e');
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          16,
          24,
          MediaQuery.paddingOf(context).bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l.applySheetTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary,
                      letterSpacing: -0.36,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const IthakiIcon('x-close',
                      size: 20, color: IthakiTheme.softGraphite),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l.applySheetSubtitle,
              style: const TextStyle(
                fontSize: 14,
                color: IthakiTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            _ApplyOption(
              title: l.applyOptionIthakiCvTitle,
              subtitle: l.applyOptionIthakiCvSubtitle,
              selected: _cvOption == _CvOption.ithaki,
              onTap: () => setState(() {
                _cvOption = _CvOption.ithaki;
                _error = null;
              }),
            ),
            const SizedBox(height: 12),
            _ApplyOption(
              title: l.applyOptionUploadTitle,
              subtitle: l.applyOptionUploadSubtitle,
              selected: _cvOption == _CvOption.upload,
              onTap: () => setState(() {
                _cvOption = _CvOption.upload;
                _error = null;
              }),
            ),
            if (_cvOption == _CvOption.upload) ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _submitting ? null : _pickFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: IthakiTheme.softGray,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _pickedFilePath != null
                          ? IthakiTheme.matchGreen
                          : IthakiTheme.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      IthakiIcon(
                        _pickedFilePath != null ? 'check' : 'upload-cloud',
                        size: 18,
                        color: _pickedFilePath != null
                            ? IthakiTheme.matchGreen
                            : IthakiTheme.softGraphite,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _pickedFileName != null
                              ? _pickedFileName!.split('/').last.split('\\').last
                              : l.applySelectCvFile,
                          style: TextStyle(
                            fontSize: 14,
                            color: _pickedFilePath != null
                                ? IthakiTheme.textPrimary
                                : IthakiTheme.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _coverLetterCtrl,
              enabled: !_submitting,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l.coverLetterHint,
                hintStyle: const TextStyle(
                    fontSize: 14, color: IthakiTheme.textSecondary),
                filled: true,
                fillColor: IthakiTheme.softGray,
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: IthakiTheme.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: IthakiTheme.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: IthakiTheme.primaryPurple),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _submitting ? null : () => _pickDate(context),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: IthakiTheme.softGray,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: IthakiTheme.borderLight),
                ),
                child: Row(
                  children: [
                    const IthakiIcon('calendar',
                        size: 18, color: IthakiTheme.softGraphite),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _availabilityDate != null
                            ? '${l.availabilityDateLabel}: '
                                '${_availabilityDate!.day.toString().padLeft(2, '0')}/'
                                '${_availabilityDate!.month.toString().padLeft(2, '0')}/'
                                '${_availabilityDate!.year}'
                            : l.availabilityDateHint,
                        style: TextStyle(
                          fontSize: 14,
                          color: _availabilityDate != null
                              ? IthakiTheme.textPrimary
                              : IthakiTheme.textSecondary,
                        ),
                      ),
                    ),
                    const IthakiIcon('arrow-down',
                        size: 16, color: IthakiTheme.softGraphite),
                  ],
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
                style: const TextStyle(fontSize: 13, color: Colors.red),
              ),
            ],
            const SizedBox(height: 20),
            IthakiButton(
              _submitting ? l.applySubmitting : l.applyNow,
              onPressed: _submitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplyOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ApplyOption({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? IthakiTheme.accentPurpleLight
              : IthakiTheme.softGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? IthakiTheme.primaryPurple
                : IthakiTheme.borderLight,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? IthakiTheme.primaryPurple
                          : IthakiTheme.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: IthakiTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const IthakiIcon('check',
                  size: 18, color: IthakiTheme.primaryPurple),
          ],
        ),
      ),
    );
  }
}

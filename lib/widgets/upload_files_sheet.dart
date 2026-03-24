// lib/widgets/upload_files_sheet.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../models/profile_models.dart';

/// Two-tab bottom sheet: "Upload File" and "Upload via URL".
/// Simulates upload progress with mock data.
class UploadFilesSheet extends StatefulWidget {
  final void Function(List<UploadedFile> files) onContinue;

  const UploadFilesSheet({super.key, required this.onContinue});

  static void show(BuildContext context, {required void Function(List<UploadedFile>) onContinue}) {
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

  bool get _allComplete => _files.isNotEmpty && _files.every((f) => f.isComplete);

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
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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

              // Tabs
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

              // Tab content — flexible so it doesn't overflow
              SizedBox(
                height: tabHeight,
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [
                    _buildUploadFileTab(),
                    _buildUploadUrlTab(),
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

  Widget _buildUploadFileTab() {
    if (_files.isEmpty) {
      return _buildDropZone();
    }
    return ListView(
      children: [
        ..._files.map((f) => _buildFileRow(f)),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: _pickFiles,
          style: _outlineStyle(),
          child: const Text('+ Upload More'),
        ),
      ],
    );
  }

  Widget _buildDropZone() {
    return DottedBorderBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.upload_rounded, size: 32, color: IthakiTheme.softGraphite),
          const SizedBox(height: 8),
          const Text(
            'Tap button to browse\n(max 10 files, up to 5 MB each;\nsupported: .pdf, .doc, .png, .jpg)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          IthakiButton('↑ Upload File', onPressed: _pickFiles),
        ],
      ),
    );
  }

  Widget _buildFileRow(UploadedFile f) {
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
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              f.name.contains('.')
                  ? f.name.split('.').last.toUpperCase()
                  : 'FILE',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold,
                  color: IthakiTheme.softGraphite),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(
                  f.isComplete ? '${f.size} | Complete' : '${f.size} | Uploading...',
                  style: const TextStyle(fontSize: 12, color: IthakiTheme.textSecondary),
                ),
                if (!f.isComplete) ...[
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: f.uploadProgress,
                    color: IthakiTheme.primaryPurple,
                    backgroundColor: Colors.grey.shade200,
                    minHeight: 3,
                  ),
                ],
              ],
            ),
          ),
          if (f.isComplete)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: IthakiTheme.softGraphite),
              onPressed: () => setState(() => _files.remove(f)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildUploadUrlTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Provide a link to a document to import it into the system.',
          style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        const _BulletText('The link must be active and accessible without login.'),
        const _BulletText('The document must be in a supported format (PDF, DOC, DOCX).'),
        const _BulletText('Common services: Google Drive, Dropbox, iCloud.'),
        const SizedBox(height: 12),
        TextField(
          controller: _urlCtrl,
          onChanged: (v) => setState(() {
            _urlFile = v.trim().isNotEmpty
                ? UploadedFile(name: v.trim(), size: 'URL', uploadProgress: 1.0)
                : null;
          }),
          decoration: InputDecoration(
            hintText: "Add Document's Link",
            hintStyle: const TextStyle(color: IthakiTheme.softGraphite, fontSize: 14),
            prefixIcon: const Icon(Icons.link, color: IthakiTheme.softGraphite),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: IthakiTheme.primaryPurple)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  ButtonStyle _outlineStyle() => OutlinedButton.styleFrom(
    side: BorderSide(color: Colors.grey.shade300),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    foregroundColor: IthakiTheme.textPrimary,
    textStyle: const TextStyle(fontSize: 14),
  );
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
          const Text('• ', style: TextStyle(color: IthakiTheme.textSecondary, fontSize: 13)),
          Expanded(child: Text(text,
              style: const TextStyle(color: IthakiTheme.textSecondary, fontSize: 13))),
        ],
      ),
    );
  }
}

/// Simple dashed-border container. Uses a CustomPainter.
class DottedBorderBox extends StatelessWidget {
  final Widget child;
  const DottedBorderBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashPainter(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const dashW = 6.0, gap = 4.0;
    final rr = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(12));
    final path = Path()..addRRect(rr);
    final metric = path.computeMetrics().first;
    double dist = 0;
    while (dist < metric.length) {
      canvas.drawPath(metric.extractPath(dist, dist + dashW), paint);
      dist += dashW + gap;
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => false;
}

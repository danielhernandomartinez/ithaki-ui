import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../providers/profile_provider.dart';
import '../../widgets/dotted_border_box.dart';
import '../../widgets/panel_scaffold.dart';

class EditAboutMeScreen extends ConsumerStatefulWidget {
  const EditAboutMeScreen({super.key});

  @override
  ConsumerState<EditAboutMeScreen> createState() => _EditAboutMeScreenState();
}

class _EditAboutMeScreenState extends ConsumerState<EditAboutMeScreen> {
  late TextEditingController _bioCtrl;
  late TextEditingController _videoUrlCtrl;
  String? _videoUrl;
  int _activeTab = 0; // 0 = Upload File, 1 = Upload via URL

  @override
  void initState() {
    super.initState();
    final aboutMe = ref.read(profileAboutMeProvider).requireValue;
    _bioCtrl = TextEditingController(text: aboutMe.bio);
    _videoUrl = aboutMe.videoUrl;
    _videoUrlCtrl = TextEditingController(text: aboutMe.videoUrl ?? '');
    _bioCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _bioCtrl.dispose();
    _videoUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    try {
      await ref
          .read(profileAboutMeProvider.notifier)
          .save(_bioCtrl.text.trim(), videoUrl: _videoUrl);
      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Widget _tab(String label, int index) {
    final selected = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? IthakiTheme.textPrimary : IthakiTheme.textSecondary,
          decoration: selected ? TextDecoration.underline : TextDecoration.none,
          decorationColor: IthakiTheme.textPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bioLen = _bioCtrl.text.length;

    return PanelScaffold(
      title: 'About Me',
      onSave: _save,
      children: [
              // ── Page header ────────────────────────────────────
              const Text('About Me',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 6),
              const Text(
                'Please provide some basic information about yourself. This helps us set up your profile and personalize your experience. You can add information later or update this anytime in Profile.',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              // ── Bio ────────────────────────────────────────────
              const Text('Add Bio (optional)',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 6),
              const Text(
                'Add a few words about yourself to help employers understand who you are and what you do. We recommend keeping it concise, avoiding unnecessary filler, and highlighting key skills and experience.',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _bioCtrl,
                maxLines: null,
                minLines: 6,
                maxLength: 1000,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: IthakiTheme.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: IthakiTheme.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                        color: IthakiTheme.primaryPurple, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$bioLen / 1000 symbols',
                  style: const TextStyle(
                      fontSize: 11, color: IthakiTheme.textSecondary),
                ),
              ),
              const SizedBox(height: 24),

              // ── Video ──────────────────────────────────────────
              const Text('Add Video Presentation (optional)',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 6),
              const Text(
                'Add a short video to introduce yourself to employers, highlight your experience, and showcase your skills. A video helps you stand out among other candidates.',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 12),

              // Tab row
              Row(
                children: [
                  _tab('Upload File', 0),
                  const SizedBox(width: 20),
                  _tab('Upload via URL', 1),
                ],
              ),
              const SizedBox(height: 12),

              // Tab content
              if (_activeTab == 0)
                DottedBorderBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.upload_rounded,
                          size: 32, color: IthakiTheme.softGraphite),
                      const SizedBox(height: 8),
                      const Text(
                        'tap button to browse (max 10 files, up to 5 MB\neach; supported formats: .pdf, .doc, .png, .jpg)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, color: IthakiTheme.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () async {
                          await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: [
                              'mp4', 'mov', 'avi', 'mkv',
                              'pdf', 'doc', 'docx',
                            ],
                          );
                        },
                        icon: const Icon(Icons.upload_rounded, size: 16),
                        label: const Text('Upload File'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: IthakiTheme.softGraphite),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          foregroundColor: IthakiTheme.textPrimary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                )
              else
                TextField(
                  controller: _videoUrlCtrl,
                  onChanged: (v) => setState(() =>
                      _videoUrl = v.trim().isNotEmpty ? v.trim() : null),
                  decoration: InputDecoration(
                    hintText: 'Paste video URL here',
                    hintStyle: const TextStyle(
                        color: IthakiTheme.softGraphite, fontSize: 14),
                    prefixIcon: const Icon(Icons.link,
                        color: IthakiTheme.softGraphite),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(color: IthakiTheme.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                          color: IthakiTheme.primaryPurple, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),

              if (_videoUrl != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 180,
                    color: Colors.black54,
                    alignment: Alignment.center,
                    child: const Icon(Icons.play_circle_filled_rounded,
                        size: 56, color: IthakiTheme.backgroundWhite),
                  ),
                ),
              ],

      ],
    );
  }
}

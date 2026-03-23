import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../providers/profile_provider.dart';

class EditAboutMeScreen extends ConsumerStatefulWidget {
  const EditAboutMeScreen({super.key});

  @override
  ConsumerState<EditAboutMeScreen> createState() => _EditAboutMeScreenState();
}

class _EditAboutMeScreenState extends ConsumerState<EditAboutMeScreen> {
  late TextEditingController _bioCtrl;
  String? _videoUrl;
  final _videoUrlCtrl = TextEditingController();
  int _activeTab = 0; // 0 = Upload File, 1 = Upload via URL

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    _bioCtrl = TextEditingController(text: profile.bio);
    _videoUrl = profile.videoUrl;
  }

  @override
  void dispose() {
    _bioCtrl.dispose();
    _videoUrlCtrl.dispose();
    super.dispose();
  }

  void _save() {
    ref
        .read(profileProvider.notifier)
        .updateBio(_bioCtrl.text.trim(), videoUrl: _videoUrl);
    context.pop();
  }

  Widget _videoTab(String label, int index) {
    final selected = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? IthakiTheme.primaryPurple : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? IthakiTheme.primaryPurple
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : IthakiTheme.textSecondary,
            fontSize: 13,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'About Me',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bio',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _bioCtrl,
                maxLines: null,
                minLines: 6,
                maxLength: 1000,
                buildCounter: (
                  _, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) =>
                    null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: IthakiTheme.primaryPurple,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${_bioCtrl.text.length} / 1000 symbols',
                  style: const TextStyle(
                    fontSize: 12,
                    color: IthakiTheme.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Introduction Video (optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _videoTab('Upload File', 0),
                  const SizedBox(width: 8),
                  _videoTab('Upload via URL', 1),
                ],
              ),
              const SizedBox(height: 12),
              if (_activeTab == 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.upload_rounded,
                        size: 32,
                        color: IthakiTheme.softGraphite,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to select a video file',
                        style: TextStyle(
                          fontSize: 13,
                          color: IthakiTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                TextField(
                  controller: _videoUrlCtrl,
                  onChanged: (v) => setState(
                    () => _videoUrl =
                        v.trim().isNotEmpty ? v.trim() : null,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Paste video URL here',
                    hintStyle:
                        TextStyle(color: IthakiTheme.softGraphite),
                    prefixIcon: Icon(
                      Icons.link,
                      color: IthakiTheme.softGraphite,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              if (_videoUrl != null)
                Container(
                  height: 200,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.play_circle_filled_rounded,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              const SizedBox(height: 24),
              IthakiButton('Save', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

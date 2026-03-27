import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Provide a link to a document to import it into the system.',
          style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        const _BulletText('The link must be active and accessible without login.'),
        const _BulletText(
            'The document must be in a supported format (PDF, DOC, DOCX).'),
        const _BulletText('Common services: Google Drive, Dropbox, iCloud.'),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "Add Document's Link",
            hintStyle: const TextStyle(
                color: IthakiTheme.softGraphite, fontSize: 14),
            prefixIcon:
                const Icon(Icons.link, color: IthakiTheme.softGraphite),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: IthakiTheme.primaryPurple)),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
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
              style: TextStyle(
                  color: IthakiTheme.textSecondary, fontSize: 13)),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      color: IthakiTheme.textSecondary, fontSize: 13))),
        ],
      ),
    );
  }
}

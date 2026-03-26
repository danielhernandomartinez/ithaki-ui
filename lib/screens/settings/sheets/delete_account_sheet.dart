import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class DeleteAccountSheet extends StatefulWidget {
  final BuildContext parentContext;
  const DeleteAccountSheet({super.key, required this.parentContext});

  @override
  State<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<DeleteAccountSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canDelete = _ctrl.text.toLowerCase() == 'delete';

    return BottomSheetBase(
      title: 'Confirm Account Deletion',
      onClose: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'To permanently delete your account, please type delete in the field below.\nThis action cannot be undone — all your data will be removed forever.',
            style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiTextField(
            label: "Type 'delete' to confirm",
            hint: 'Enter "delete"',
            controller: _ctrl,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: const BorderSide(color: IthakiTheme.softGraphite),
                foregroundColor: IthakiTheme.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: canDelete
                  ? () {
                      Navigator.pop(context);
                      widget.parentContext.go('/tech-comfort');
                    }
                  : null,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: canDelete ? Colors.red : Colors.grey.shade300),
                foregroundColor: canDelete ? Colors.red : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Delete Account'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

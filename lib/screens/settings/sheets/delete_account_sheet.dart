import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

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
    final l = AppLocalizations.of(context)!;
    final canDelete = _ctrl.text.toLowerCase() == 'delete';

    return BottomSheetBase(
      title: l.confirmAccountDeletion,
      onClose: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.deleteAccountDescription,
            style:
                const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiTextField(
            label: l.typeDeleteToConfirm,
            hint: l.enterDeleteHint,
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
              child: Text(l.cancel),
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
              child: Text(l.deleteAccountButton),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

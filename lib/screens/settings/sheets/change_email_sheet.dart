import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../providers/profile_provider.dart';
import 'verification_sheet.dart';

class ChangeEmailSheet extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  const ChangeEmailSheet({super.key, required this.parentContext});

  @override
  ConsumerState<ChangeEmailSheet> createState() => _ChangeEmailSheetState();
}

class _ChangeEmailSheetState extends ConsumerState<ChangeEmailSheet> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileBasicsProvider).value;

    return BottomSheetBase(
      title: 'Change Email',
      onClose: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update your email address',
            style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          Text(
            'Current Email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile?.email ?? '',
            style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiTextField(
            label: 'New Email',
            hint: 'Enter new email',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          IthakiButton(
            'Update',
            onPressed: _emailCtrl.text.trim().isNotEmpty
                ? () {
                    Navigator.pop(context);
                    showVerificationSheet(
                      widget.parentContext,
                      newValue: _emailCtrl.text,
                      isEmail: true,
                    );
                  }
                : null,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

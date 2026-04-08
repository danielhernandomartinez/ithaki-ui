import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../providers/profile_provider.dart';
import 'verification_sheet.dart';

class ChangePhoneSheet extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  const ChangePhoneSheet({super.key, required this.parentContext});

  @override
  ConsumerState<ChangePhoneSheet> createState() => _ChangePhoneSheetState();
}

class _ChangePhoneSheetState extends ConsumerState<ChangePhoneSheet> {
  final _phoneCtrl = TextEditingController();
  bool _valid = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileBasicsProvider).value;

    return BottomSheetBase(
      title: 'Change Phone Number',
      onClose: () => Navigator.pop(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const Text(
            'Current Phone Number',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile?.phone ?? '',
            style: const TextStyle(
                fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiPhoneField(
            controller: _phoneCtrl,
            label: 'New Phone Number',
            onValidationChanged: (v) => setState(() => _valid = v),
          ),
          const SizedBox(height: 20),
          IthakiButton(
            'Update',
            onPressed: _valid
                ? () {
                    Navigator.pop(context);
                    showVerificationSheet(
                      widget.parentContext,
                      newValue: _phoneCtrl.text,
                      isEmail: false,
                    );
                  }
                : null,
          ),
          const SizedBox(height: 8),
        ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../config/app_config.dart';
import '../../../l10n/app_localizations.dart';
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

  bool get _canUpdate =>
      _valid ||
      (AppConfig.bypassPhoneValidation && _phoneCtrl.text.trim().isNotEmpty);

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final profile = ref.watch(profileBasicsProvider).value;

    return BottomSheetBase(
      title: l.changePhoneTitle,
      onClose: () => Navigator.pop(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.currentPhoneNumberLabel,
              style: const TextStyle(
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
              label: l.newPhoneNumberLabel,
              onChanged: (_) => setState(() {}),
              onValidationChanged: (v) => setState(() => _valid = v),
            ),
            const SizedBox(height: 20),
            IthakiButton(
              l.updateButton,
              onPressed: _canUpdate
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

import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../l10n/app_localizations.dart';

class SalaryFieldRow extends StatelessWidget {
  final TextEditingController controller;
  final bool preferNotToSpecify;
  final String paymentTerm;
  final ValueChanged<String> onPaymentTermChanged;
  final ValueChanged<bool> onPreferNotToSpecifyChanged;

  const SalaryFieldRow({
    super.key,
    required this.controller,
    required this.preferNotToSpecify,
    required this.paymentTerm,
    required this.onPaymentTermChanged,
    required this.onPreferNotToSpecifyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return IthakiSalaryInput(
      amountController: controller,
      paymentTerm: paymentTerm.isEmpty ? null : paymentTerm,
      paymentTermOptions: [
        SearchItem(id: 'Monthly', label: l.payMonthly),
        SearchItem(id: 'Yearly', label: l.payYearly),
      ],
      onPaymentTermChanged: onPaymentTermChanged,
      preferNotToSpecify: preferNotToSpecify,
      onPreferNotToSpecifyChanged: onPreferNotToSpecifyChanged,
      expectedPaymentLabel: l.expectedPaymentLabel,
      fromLabel: l.fromLabel,
      paymentTermLabel: l.paymentTermTitle,
      paymentTermPlaceholder: l.selectAction,
      preferNotToSpecifyLabel: l.preferNotToSpecify,
    );
  }
}

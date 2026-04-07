import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

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
    return IthakiSalaryInput(
      amountController: controller,
      paymentTerm: paymentTerm.isEmpty ? null : paymentTerm,
      paymentTermOptions: const [
        SearchItem(id: 'Monthly', label: 'Monthly'),
        SearchItem(id: 'Yearly', label: 'Yearly'),
      ],
      onPaymentTermChanged: onPaymentTermChanged,
      preferNotToSpecify: preferNotToSpecify,
      onPreferNotToSpecifyChanged: onPreferNotToSpecifyChanged,
      expectedPaymentLabel: 'Expected Payment',
      fromLabel: 'From',
      paymentTermLabel: 'Payment Term',
      paymentTermPlaceholder: 'Select',
      preferNotToSpecifyLabel: 'Prefer not to specify',
    );
  }
}

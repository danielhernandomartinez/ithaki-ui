import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'profile_picker_field.dart';

class SalaryFieldRow extends StatelessWidget {
  final TextEditingController controller;
  final bool preferNotToSpecify;
  final String paymentTerm;
  final VoidCallback onPaymentTermTap;
  final ValueChanged<bool> onPreferNotToSpecifyChanged;

  const SalaryFieldRow({
    super.key,
    required this.controller,
    required this.preferNotToSpecify,
    required this.paymentTerm,
    required this.onPaymentTermTap,
    required this.onPreferNotToSpecifyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Expected Payment From',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: controller,
                    enabled: !preferNotToSpecify,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: const TextStyle(color: IthakiTheme.softGraphite),
                      suffixText: '€',
                      suffixStyle: const TextStyle(
                          fontSize: 14, color: IthakiTheme.textSecondary),
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
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: IthakiTheme.borderLight),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ProfilePickerField(
                label: 'Payment Term',
                hint: 'Select',
                value: paymentTerm,
                fontSize: 14,
                verticalPadding: 11,
                arrowSize: 18,
                onTap: onPaymentTermTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        IthakiCheckbox(
          value: preferNotToSpecify,
          onChanged: onPreferNotToSpecifyChanged,
          child: const Text('Prefer not to specify',
              style: TextStyle(fontSize: 14, color: IthakiTheme.textPrimary)),
        ),
      ],
    );
  }
}

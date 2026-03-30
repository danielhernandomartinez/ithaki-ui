import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../models/profile_models.dart';

class AddJobInterestSheet extends StatefulWidget {
  final void Function(JobInterest) onAdd;

  const AddJobInterestSheet({super.key, required this.onAdd});

  static void show(BuildContext context, {required void Function(JobInterest) onAdd}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: IthakiTheme.backgroundWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: AddJobInterestSheet(onAdd: onAdd),
      ),
    );
  }

  @override
  State<AddJobInterestSheet> createState() => _AddJobInterestSheetState();
}

class _AddJobInterestSheetState extends State<AddJobInterestSheet> {
  final _titleCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add Job Interest',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 16),
          IthakiTextField(
            label: 'Job Title',
            hint: 'e.g. Web Developer',
            controller: _titleCtrl,
          ),
          const SizedBox(height: 12),
          IthakiTextField(
            label: 'Category',
            hint: 'e.g. IT & Development',
            controller: _categoryCtrl,
          ),
          const SizedBox(height: 20),
          IthakiButton('Add', onPressed: () {
            final title = _titleCtrl.text.trim();
            final category = _categoryCtrl.text.trim();
            if (title.isEmpty || category.isEmpty) return;
            widget.onAdd(JobInterest(title: title, category: category));
            Navigator.of(context).pop();
          }),
        ],
      ),
    );
  }
}

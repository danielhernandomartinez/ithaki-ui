import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../models/profile_models.dart';
import '../providers/reference_data_provider.dart';

class AddJobInterestSheet extends ConsumerStatefulWidget {
  final void Function(JobInterest) onAdd;

  const AddJobInterestSheet({super.key, required this.onAdd});

  static void show(
    BuildContext context, {
    required void Function(JobInterest) onAdd,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: IthakiTheme.backgroundWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddJobInterestSheet(onAdd: onAdd),
    );
  }

  @override
  ConsumerState<AddJobInterestSheet> createState() =>
      _AddJobInterestSheetState();
}

class _AddJobInterestSheetState extends ConsumerState<AddJobInterestSheet> {
  @override
  Widget build(BuildContext context) {
    final interestsAsync = ref.watch(jobInterestsListProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Job Interest',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (interestsAsync.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (interestsAsync.hasError)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: IthakiTheme.softGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: IthakiTheme.borderLight),
              ),
              child: Text(
                interestsAsync.error.toString(),
                style: IthakiTheme.captionRegular,
              ),
            )
          else
            SizedBox(
              height: 360,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: interestsAsync.value?.length ?? 0,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = interestsAsync.value![index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      widget.onAdd(
                        JobInterest(
                          id: item.id.toString(),
                          title: item.title,
                          category: item.category,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: IthakiTheme.borderLight),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: IthakiTheme.bodyRegular.copyWith(
                                    color: IthakiTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (item.category.trim().isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    item.category,
                                    style: IthakiTheme.captionRegular.copyWith(
                                      color: IthakiTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const IthakiIcon(
                            'plus',
                            size: 16,
                            color: IthakiTheme.primaryPurple,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

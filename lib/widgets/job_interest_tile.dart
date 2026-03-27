import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../models/profile_models.dart';

class JobInterestTile extends StatelessWidget {
  final JobInterest interest;
  final VoidCallback onRemove;

  const JobInterestTile({
    super.key,
    required this.interest,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: const IthakiIcon('rocket', size: 20, color: IthakiTheme.primaryPurple),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(interest.title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary)),
              Text(interest.category,
                  style: const TextStyle(
                      fontSize: 13, color: IthakiTheme.textSecondary)),
            ],
          ),
        ),
        GestureDetector(
          onTap: onRemove,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const IthakiIcon('delete', size: 16, color: IthakiTheme.softGraphite),
          ),
        ),
      ]),
    );
  }
}

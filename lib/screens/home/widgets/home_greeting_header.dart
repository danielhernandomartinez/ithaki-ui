import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../data/mock_home_data.dart';

class HomeGreetingHeader extends StatelessWidget {
  final double topOffset;

  const HomeGreetingHeader({super.key, required this.topOffset});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: topOffset + 12,
        left: 16,
        right: 16,
        bottom: 0,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, ${MockHomeData.userName}!',
            style: IthakiTheme.headingLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Here's a quick overview of your latest job matches, updates, and helpful tips to move your career forward.",
            style: IthakiTheme.bodyRegular.copyWith(
              color: IthakiTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

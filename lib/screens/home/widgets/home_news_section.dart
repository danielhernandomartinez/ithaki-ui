import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../data/mock_home_data.dart';

class HomeNewsSection extends StatelessWidget {
  const HomeNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final newsList = MockHomeData.news;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Latest News', style: IthakiTheme.headingMedium),
        const SizedBox(height: 12),
        for (int i = 0; i < newsList.length; i++) ...[
          IthakiNewsTile(
            tag: newsList[i].tag,
            date: newsList[i].date,
            title: newsList[i].title,
          ),
          if (i < newsList.length - 1)
            const Divider(height: 24, color: IthakiTheme.borderLight),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: IthakiTheme.borderLight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Discover All News',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

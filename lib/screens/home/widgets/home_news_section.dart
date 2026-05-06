import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/home_provider.dart';
import '../../../routes.dart';

class HomeNewsSection extends ConsumerWidget {
  const HomeNewsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsList = ref.watch(homeProvider).value?.news ?? [];
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.homeLatestNews, style: IthakiTheme.headingMedium),
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
            onPressed: () => context.go(Routes.blogNews),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: IthakiTheme.borderLight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              l10n.blogDiscoverAll,
              style: const TextStyle(
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

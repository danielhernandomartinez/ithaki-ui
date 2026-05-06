import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/home_provider.dart';

class HomeGreetingHeader extends ConsumerWidget {
  final double topOffset;

  const HomeGreetingHeader({super.key, required this.topOffset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(homeProvider).value;
    if (homeData == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    final name = homeData.userName.trim();
    final greeting = name.isEmpty ? l10n.homeGreetingNoName : l10n.homeGreetingName(name);
    return Container(
      margin: EdgeInsets.only(
        top: topOffset + 12,
        left: 16,
        right: 16,
        bottom: 0,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: IthakiTheme.headingLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.homeGreetingSubtitle,
            style: IthakiTheme.bodyRegular.copyWith(
              color: IthakiTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

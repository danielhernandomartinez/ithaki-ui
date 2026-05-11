import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/company_provider.dart';
import '../../providers/home_provider.dart';
import '../../routes.dart';
import '../../widgets/main_panel_scaffold.dart';
import 'company_profile_content.dart';

class CompanyProfileScreen extends ConsumerStatefulWidget {
  const CompanyProfileScreen({super.key, required this.companyId});

  final String companyId;

  @override
  ConsumerState<CompanyProfileScreen> createState() =>
      _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends ConsumerState<CompanyProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: kCompanyTabCount,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyAsync = ref.watch(companyProvider(widget.companyId));
    final homeData = ref.watch(homeProvider).value;

    return MainPanelScaffold(
      currentRoute: Routes.jobSearch,
      showBackButton: true,
      avatarInitials: homeData?.userInitials ?? 'CI',
      avatarUrl: homeData?.userPhotoUrl,
      bodyBuilder: (context, ref, topOffset) => companyAsync.when(
        loading: () => _Centered(
          topOffset: topOffset,
          child: const CircularProgressIndicator(),
        ),
        error: (_, __) => _Centered(
          topOffset: topOffset,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.companyLoadError,
                style: const TextStyle(
                  color: IthakiTheme.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              IthakiButton(
                AppLocalizations.of(context)!.tryAgain,
                onPressed: () =>
                    ref.invalidate(companyProvider(widget.companyId)),
              ),
            ],
          ),
        ),
        data: (company) => CompanyProfileContent(
          company: company,
          tabController: _tabController,
          topOffset: topOffset,
        ),
      ),
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.topOffset, required this.child});

  final double topOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topOffset),
      child: Center(child: child),
    );
  }
}

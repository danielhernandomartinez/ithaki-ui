import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/home_provider.dart';
import '../../providers/invitations_provider.dart';
import '../../providers/tour_provider.dart';
import '../../routes.dart';
import '../../widgets/main_panel_scaffold.dart';
import 'widgets/application_banners.dart';
import 'widgets/applications_tab_bar.dart';
import 'widgets/archive_tab.dart';
import 'widgets/drafts_tab.dart';
import 'widgets/invitations_tab.dart';
import 'widgets/my_applications_tab.dart';

class MyApplicationsScreen extends ConsumerStatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  ConsumerState<MyApplicationsScreen> createState() =>
      _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends ConsumerState<MyApplicationsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  String? _pendingDismissId;
  Timer? _dismissTimer;
  bool _showSuccessBanner = false;
  Timer? _successTimer;
  bool _showDeclinedBanner = false;
  Timer? _declinedTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this)
      ..addListener(() {
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dismissTimer?.cancel();
    _successTimer?.cancel();
    _declinedTimer?.cancel();
    super.dispose();
  }

  void _onDismissRequested(String invitationId) {
    _dismissTimer?.cancel();
    setState(() {
      _pendingDismissId = invitationId;
      _showSuccessBanner = false;
    });
    _dismissTimer = Timer(const Duration(seconds: 5), () async {
      if (!mounted) return;
      await ref.read(invitationsProvider.notifier).dismiss(invitationId);
      if (!mounted) return;
      setState(() {
        _pendingDismissId = null;
        _showSuccessBanner = true;
      });
      _successTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showSuccessBanner = false);
      });
    });
  }

  void _onUndo() {
    _dismissTimer?.cancel();
    setState(() => _pendingDismissId = null);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final homeAsync = ref.watch(homeProvider);
    final invitationsAsync = ref.watch(invitationsProvider);
    final tourState = ref.watch(tourProvider).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    final tourKeys = ref.watch(tourKeysProvider);
    final desiredTabIndex = switch (tourState?.currentStep) {
      7 => 0,
      8 => 1,
      _ => null,
    };

    if (desiredTabIndex != null && _tabController.index != desiredTabIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _tabController.index != desiredTabIndex) {
          _tabController.animateTo(desiredTabIndex);
        }
      });
    }

    final invitationsCount =
        invitationsAsync.value?.where((i) => !i.isDismissed).length ?? 0;

    ref.listen<bool>(invitationDeclinedProvider, (_, next) {
      if (next && mounted) {
        ref.read(invitationDeclinedProvider.notifier).set(false);
        _declinedTimer?.cancel();
        setState(() {
          _showDeclinedBanner = true;
          _tabController.animateTo(3);
        });
        _declinedTimer = Timer(const Duration(seconds: 5), () {
          if (mounted) setState(() => _showDeclinedBanner = false);
        });
      }
    });

    return MainPanelScaffold(
      currentRoute: Routes.myApplications,
      avatarInitials: homeAsync.value?.userInitials ?? '',
      avatarUrl: homeAsync.value?.userPhotoUrl,
      bodyBuilder: (context, ref, topOffset) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: topOffset),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ApplicationsTabBar(
                controller: _tabController,
                invitationsCount: invitationsCount,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              key: tourState?.currentStep == 7 || tourState?.currentStep == 8
                  ? tourKeys[tourState!.currentStep]
                  : null,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: IthakiTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(12),
              child: _tabBody(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IthakiGradientBanner(
                title: l.careerAssistantBannerTitle,
                subtitle: l.careerAssistantBannerSubtitle,
                buttonLabel: l.askCareerAssistant,
                buttonIcon: const IthakiIcon(
                  'ai',
                  size: 18,
                  color: IthakiTheme.backgroundWhite,
                ),
                onButtonPressed: () => context.go(Routes.careerAssistant),
                backgroundImage: const DecorationImage(
                  image: AssetImage('assets/images/ai_banner_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
          ],
        ),
      ),
      overlayBuilder: (context, ref, topOffset) => [
        if (_pendingDismissId != null)
          _banner(topOffset, DismissBanner(onUndo: _onUndo)),
        if (_showSuccessBanner)
          _banner(
            topOffset,
            ToastBanner(
              message: l.invitationDismissedToast,
              onClose: () => setState(() => _showSuccessBanner = false),
            ),
          ),
        if (_showDeclinedBanner)
          _banner(
            topOffset,
            ToastBanner(
              message: l.invitationDeclinedToast,
              onClose: () {
                _declinedTimer?.cancel();
                setState(() => _showDeclinedBanner = false);
              },
            ),
          ),
      ],
    );
  }

  Widget _tabBody() {
    switch (_tabController.index) {
      case 0:
        return const MyApplicationsTab();
      case 1:
        return InvitationsTab(
          pendingDismissId: _pendingDismissId,
          onDismissRequested: _onDismissRequested,
        );
      case 2:
        return const DraftsTab();
      case 3:
        return const ArchiveTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Positioned _banner(double topOffset, Widget child) => Positioned(
        top: topOffset - 8,
        left: 16,
        right: 16,
        child: child,
      );
}

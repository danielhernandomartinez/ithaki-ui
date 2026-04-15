import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../routes.dart';
import '../../providers/profile_provider.dart';
import '../../providers/blog_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/blog_search_bar.dart';
import 'widgets/blog_category_chips.dart';
import 'widgets/blog_article_card.dart';
import 'widgets/blog_pagination.dart';

class BlogNewsScreen extends ConsumerStatefulWidget {
  const BlogNewsScreen({super.key});

  @override
  ConsumerState<BlogNewsScreen> createState() => _BlogNewsScreenState();
}

class _BlogNewsScreenState extends ConsumerState<BlogNewsScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;

  @override
  void initState() {
    super.initState();
    _panels = PanelMenuController(setState)..init(this);
  }

  @override
  void dispose() {
    _panels.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;
    final articles = ref.watch(blogProvider).paginated;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        menuOpen: _panels.menuOpen,
        profileOpen: _panels.profileOpen,
        avatarInitials:
            ref.watch(profileBasicsProvider).value?.initials ?? '',
        onMenuPressed: _panels.toggleMenu,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(
        children: [
          // ─── Main content ──────────────────────────────────────────
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: topOffset + 12),
                // Title + subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.blogNewsTitle, style: IthakiTheme.headingLarge),
                      const SizedBox(height: 4),
                      Text(
                        l10n.blogNewsSubtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: IthakiTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const BlogSearchBar(),
                const SizedBox(height: 12),
                const BlogCategoryChips(),
                const SizedBox(height: 16),
                // Article cards
                for (final article in articles) ...[
                  BlogArticleCard(article: article),
                  const SizedBox(height: 12),
                ],
                const BlogPagination(),
                const SizedBox(height: 16),
                // AI Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IthakiGradientBanner(
                    title: 'Not sure how to find the right job?',
                    subtitle:
                        "Career Assistant can help you if you're not sure where to start!",
                    buttonLabel: 'Ask Career Assistant',
                    buttonIcon: const IthakiIcon(
                        'ai', size: 18, color: IthakiTheme.backgroundWhite),
                    onButtonPressed: () {},
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

          // ─── Dim overlay ───────────────────────────────────────────
          if (_panels.menuOpen || _panels.profileOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _panels.closeMenu();
                  _panels.closeProfile();
                },
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),

          // ─── Nav panel ─────────────────────────────────────────────
          if (_panels.menuOpen ||
              _panels.menuCtrl.status != AnimationStatus.dismissed)
            Positioned(
              top: topOffset - 14,
              left: 16,
              right: 16,
              bottom: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SlideTransition(
                  position: _panels.slideAnim,
                  child: AppNavDrawer(
                    currentRoute: Routes.blogNews,
                    profileProgress: ref.watch(profileCompletionProvider),
                    items: kAppNavItems,
                    onItemTap: (item) {
                      _panels.closeMenu();
                      if (item.route != Routes.blogNews) {
                        context.go(item.route);
                      }
                    },
                  ),
                ),
              ),
            ),

          // ─── Profile panel ─────────────────────────────────────────
          if (_panels.profileOpen ||
              _panels.profileCtrl.status != AnimationStatus.dismissed)
            Positioned(
              top: topOffset - 14,
              left: 16,
              right: 16,
              bottom: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SlideTransition(
                  position: _panels.profileSlideAnim,
                  child: ProfileMenuPanel(
                    onItemTap: (item) {
                      _panels.closeProfile();
                      if (item.route.isNotEmpty) context.push(item.route);
                    },
                    onLogOut: () {
                      _panels.closeProfile();
                      ref
                          .read(authRepositoryProvider)
                          .logout()
                          .whenComplete(() {
                        resetProfileProviders(ref);
                        if (context.mounted) context.go(Routes.root);
                      });
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../constants/nav_items.dart';
import '../../l10n/app_localizations.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../providers/blog_provider.dart';
import '../../providers/profile_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import 'widgets/blog_article_related.dart';
import 'widgets/blog_article_share_row.dart';

class BlogArticleScreen extends ConsumerStatefulWidget {
  final String articleId;

  const BlogArticleScreen({super.key, required this.articleId});

  @override
  ConsumerState<BlogArticleScreen> createState() => _BlogArticleScreenState();
}

class _BlogArticleScreenState extends ConsumerState<BlogArticleScreen>
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

    final article = ref
        .watch(blogProvider)
        .articles
        .where((a) => a.id == widget.articleId)
        .firstOrNull;

    if (article == null) {
      return Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        appBar: IthakiAppBar(showBackButton: true, title: l10n.blogNewsTitle),
        body: Center(
          child: Text(
            l10n.blogArticleNotFound,
            style: const TextStyle(color: IthakiTheme.textPrimary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        menuOpen: _panels.menuOpen,
        profileOpen: _panels.profileOpen,
        avatarInitials:
            ref.watch(profileBasicsProvider).value?.initials ?? '',
        avatarUrl: ref.watch(profileBasicsProvider).value?.photoUrl,
        onMenuPressed: _panels.toggleMenu,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(
        children: [
          // ─── Scrollable content ────────────────────────────────────────
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: topOffset - 16),

                // ── Hero image ─────────────────────────────────────────
                Image.asset(
                  article.imageAsset,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                // ── Back link + article card ───────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back link
                      GestureDetector(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(Routes.blogNews);
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const IthakiIcon(
                              'arrow-left',
                              size: 16,
                              color: IthakiTheme.primaryPurple,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              l10n.backButton,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: IthakiTheme.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Article card
                      IthakiCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category
                            Text(
                              article.category,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: IthakiTheme.primaryPurple,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Title
                            Text(
                              article.title,
                              style: IthakiTheme.headingLarge,
                            ),
                            const SizedBox(height: 8),

                            // Description
                            Text(
                              article.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: IthakiTheme.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Author · read time · date
                            Row(
                              children: [
                                Text(
                                  l10n.blogArticleBy(article.author),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: IthakiTheme.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  '·',
                                  style: TextStyle(
                                    color: IthakiTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  article.readTime,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: IthakiTheme.textSecondary,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  article.date,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: IthakiTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Article body ─────────────────────────────────
                      IthakiCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final section in article.body) ...[
                              if (section.heading != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  section.heading!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: IthakiTheme.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              for (final para in section.paragraphs) ...[
                                Text(
                                  para,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: IthakiTheme.textPrimary,
                                    height: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Tags ─────────────────────────────────────────
                      if (article.tags.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: article.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: IthakiTheme.backgroundWhite,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: IthakiTheme.borderLight),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: IthakiTheme.textSecondary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 16),

                      // ── Share row ─────────────────────────────────────
                      const BlogArticleShareRow(),

                      const SizedBox(height: 24),

                      // ── Related articles ──────────────────────────────
                      BlogRelatedSection(currentArticleId: widget.articleId),

                      const SizedBox(height: 20),

                      // ── Discover All News CTA ─────────────────────────
                      SizedBox(
                        width: double.infinity,
                        child: IthakiOutlineButton(
                          l10n.blogDiscoverAll,
                          onPressed: () => context.go(Routes.blogNews),
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.paddingOf(context).bottom + 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ─── Dim overlay ───────────────────────────────────────────────
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

          // ─── Nav panel ─────────────────────────────────────────────────
          if (_panels.menuOpen ||
              _panels.menuCtrl.status != AnimationStatus.dismissed)
            _panel(
              topOffset,
              SlideTransition(
                position: _panels.slideAnim,
                child: AppNavDrawer(
                  currentRoute: Routes.blogNews,
                  profileProgress: ref.watch(profileCompletionProvider),
                  items: kAppNavItems,
                  onItemTap: (item) {
                    _panels.closeMenu();
                    context.go(item.route);
                  },
                ),
              ),
            ),

          // ─── Profile panel ──────────────────────────────────────────────
          if (_panels.profileOpen ||
              _panels.profileCtrl.status != AnimationStatus.dismissed)
            _panel(
              topOffset,
              SlideTransition(
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
        ],
      ),
    );
  }

  Positioned _panel(double topOffset, Widget child) => Positioned(
        top: topOffset - 14,
        left: 16,
        right: 16,
        bottom: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: child,
        ),
      );
}

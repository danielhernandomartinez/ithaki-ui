# Blog & News Screen — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Blog & News screen with category chips, full-text search, and client-side pagination (4 articles per page) backed by mock data.

**Architecture:** Dedicated `BlogNotifier extends Notifier<BlogState>` holds the full mock list plus search/filter/page state; all derived lists are computed getters. Four focused widgets (`BlogSearchBar`, `BlogCategoryChips`, `BlogArticleCard`, `BlogPagination`) compose into `BlogNewsScreen` using the same `PanelMenuController` + `IthakiAppBar` pattern as `JobSearchScreen`.

**Tech Stack:** Flutter 3.x, Riverpod 3 (`Notifier`), GoRouter 17, `ithaki_design_system`, ARB localization.

---

## File Map

| Action | Path | Responsibility |
|--------|------|----------------|
| Create | `lib/models/blog_models.dart` | `BlogArticle` data class |
| Create | `lib/providers/blog_provider.dart` | `BlogState` + `BlogNotifier` + `blogProvider` |
| Create | `lib/screens/blog/blog_news_screen.dart` | Main screen (layout + panels) |
| Create | `lib/screens/blog/widgets/blog_search_bar.dart` | Search `TextField` |
| Create | `lib/screens/blog/widgets/blog_category_chips.dart` | Horizontal scrollable chips |
| Create | `lib/screens/blog/widgets/blog_article_card.dart` | Article card with image + meta |
| Create | `lib/screens/blog/widgets/blog_pagination.dart` | Numbered page row |
| Create | `test/providers/blog_provider_test.dart` | Unit tests for `BlogNotifier` |
| Modify | `lib/routes.dart` | Add `blogNews = '/blog'` constant |
| Modify | `lib/router.dart` | Register `GoRoute` for `/blog` |
| Modify | `lib/l10n/app_en.arb` | New localization keys |
| Modify | `lib/l10n/app_el.arb` | Greek translations |
| Modify | `lib/l10n/app_ar.arb` | Arabic translations |
| Modify | `lib/screens/home/widgets/home_news_section.dart` | Wire "Discover All News" button to `/blog` |

---

## Task 1: Data model

**Files:**
- Create: `lib/models/blog_models.dart`

- [ ] **Step 1: Create `BlogArticle` model**

```dart
// lib/models/blog_models.dart

class BlogArticle {
  final String id;
  final String imageAsset;
  final String category;
  final String title;
  final String description;
  final String author;
  final String date;

  const BlogArticle({
    required this.id,
    required this.imageAsset,
    required this.category,
    required this.title,
    required this.description,
    required this.author,
    required this.date,
  });
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/models/blog_models.dart
git commit -m "feat(blog): add BlogArticle model"
```

---

## Task 2: BlogState + BlogNotifier

**Files:**
- Create: `lib/providers/blog_provider.dart`
- Create: `test/providers/blog_provider_test.dart`

- [ ] **Step 1: Write failing tests**

```dart
// test/providers/blog_provider_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/providers/blog_provider.dart';

ProviderContainer makeContainer() => ProviderContainer();

void main() {
  group('BlogNotifier', () {
    test('initial state has 20 articles, page 1, no filter', () {
      final c = makeContainer();
      addTearDown(c.dispose);
      final state = c.read(blogProvider);
      expect(state.articles.length, 20);
      expect(state.currentPage, 1);
      expect(state.activeCategory, isNull);
      expect(state.searchQuery, '');
    });

    test('paginated returns exactly 4 articles', () {
      final c = makeContainer();
      addTearDown(c.dispose);
      expect(c.read(blogProvider).paginated.length, 4);
    });

    test('setPage changes page', () {
      final c = makeContainer();
      addTearDown(c.dispose);
      c.read(blogProvider.notifier).setPage(2);
      expect(c.read(blogProvider).currentPage, 2);
    });

    test('setSearch filters articles and resets to page 1', () {
      final c = makeContainer();
      addTearDown(c.dispose);
      c.read(blogProvider.notifier).setPage(2);
      c.read(blogProvider.notifier).setSearch('How to Write');
      final state = c.read(blogProvider);
      expect(state.currentPage, 1);
      for (final a in state.filtered) {
        expect(
          a.title.toLowerCase().contains('how to write') ||
              a.description.toLowerCase().contains('how to write'),
          isTrue,
        );
      }
    });

    test('setCategory filters by category and resets to page 1', () {
      final c = makeContainer();
      addTearDown(c.dispose);
      c.read(blogProvider.notifier).setPage(2);
      c.read(blogProvider.notifier).setCategory('#Interviews');
      final state = c.read(blogProvider);
      expect(state.currentPage, 1);
      for (final a in state.filtered) {
        expect(a.category, '#Interviews');
      }
    });

    test('setCategory null shows all articles', () {
      final c = makeContainer();
      addTearDown(c.dispose);
      c.read(blogProvider.notifier).setCategory('#Interviews');
      c.read(blogProvider.notifier).setCategory(null);
      expect(c.read(blogProvider).filtered.length, 20);
    });

    test('totalPages is ceil(filtered / 4)', () {
      final c = makeContainer();
      addTearDown(c.dispose);
      expect(c.read(blogProvider).totalPages, 5); // 20 / 4
    });
  });
}
```

- [ ] **Step 2: Run tests — expect FAIL**

```bash
cd c:/Users/User/Desktop/Ithaki
flutter test test/providers/blog_provider_test.dart
```

Expected: compile error — `blog_provider.dart` doesn't exist yet.

- [ ] **Step 3: Implement `BlogState` + `BlogNotifier`**

```dart
// lib/providers/blog_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/blog_models.dart';

// ─── Mock data ────────────────────────────────────────────────────────────────

const _kCategories = [
  '#Career Tips',
  '#Interviews',
  '#Networking',
  '#CV & Portfolio',
  '#Life Resources',
  '#Work Search',
  '#Success Stories',
];

// 20 mock articles cycling through all categories.
List<BlogArticle> _buildMockArticles() {
  const titles = [
    'How to Write a CV That Gets Noticed',
    'Networking 101: Building Connections for Success',
    '10 Common Interview Questions (and How to Answer Them)',
    'How to Stay Motivated During Your Job Search',
    'Top 5 Skills Employers Want in 2025',
    'How to Track Your Applications on the Platform',
    'Crafting a Standout Cover Letter',
    'The Power of a Professional Online Presence',
    'Acing Your First Day at a New Job',
    'Negotiating Your Salary with Confidence',
    'Remote Work: Pros, Cons, and How to Thrive',
    'Understanding Job Descriptions Like a Pro',
    'How to Use LinkedIn to Land Your Dream Job',
    'Common CV Mistakes and How to Avoid Them',
    'Preparing for a Panel Interview',
    'Work-Life Balance: Tips for Job Seekers',
    'Building a Personal Brand That Gets You Hired',
    'How to Ask for a Raise',
    'Setting Career Goals That Actually Work',
    'Making the Most of Job Fairs',
  ];

  const descriptions = [
    'Practical tips on structure, layout, and wording for a clear, professional CV.',
    'Learn how to connect with professionals, build genuine relationships, and use networking in your job search.',
    'Short, effective answers to the most popular interview questions.',
    'Simple ways to stay consistent, handle rejections, and keep your confidence high.',
    'Discover which soft and hard skills are most valued by companies right now.',
    'Step-by-step guide on using the My Applications page to follow your progress.',
    'Everything you need to write a letter that stands out from the crowd.',
    'Why your digital footprint matters and how to polish it before applying.',
    'First impressions count — here\'s how to make a great start.',
    'Know your worth and learn to negotiate effectively.',
    'Is remote work right for you? Tips to stay productive from home.',
    'Decode job listings and focus on what actually matters.',
    'Profile tips, connection strategies, and the right way to reach out.',
    'Avoid the pitfalls that cost candidates their shot.',
    'Multi-interviewer format — how to manage eye contact, nerves, and answers.',
    'Stay healthy and energized throughout a long job search.',
    'Consistency, authenticity, and visibility — the three pillars.',
    'Timing, framing, and what to say when your boss asks why.',
    'SMART goals adapted for career planning.',
    'How to stand out, collect contacts, and follow up.',
  ];

  return List.generate(20, (i) {
    return BlogArticle(
      id: 'article_$i',
      imageAsset: 'assets/images/ai_banner_bg.png',
      category: _kCategories[i % _kCategories.length],
      title: titles[i],
      description: descriptions[i],
      author: 'Ithaki Team',
      date: i == 0 ? 'Today, 19:55' : 'Yesterday, 19:00',
    );
  });
}

// ─── State ────────────────────────────────────────────────────────────────────

class BlogState {
  final List<BlogArticle> articles;
  final String searchQuery;
  final String? activeCategory;
  final int currentPage;

  static const int pageSize = 4;

  const BlogState({
    required this.articles,
    this.searchQuery = '',
    this.activeCategory,
    this.currentPage = 1,
  });

  List<BlogArticle> get filtered {
    return articles.where((a) {
      final matchesCategory =
          activeCategory == null || a.category == activeCategory;
      final q = searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          a.title.toLowerCase().contains(q) ||
          a.description.toLowerCase().contains(q);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<BlogArticle> get paginated {
    final all = filtered;
    final start = (currentPage - 1) * pageSize;
    final end = (start + pageSize).clamp(0, all.length);
    if (start >= all.length) return [];
    return all.sublist(start, end);
  }

  int get totalPages {
    final count = filtered.length;
    if (count == 0) return 1;
    return (count / pageSize).ceil();
  }

  BlogState copyWith({
    String? searchQuery,
    String? Function()? activeCategory,
    int? currentPage,
  }) =>
      BlogState(
        articles: articles,
        searchQuery: searchQuery ?? this.searchQuery,
        activeCategory:
            activeCategory != null ? activeCategory() : this.activeCategory,
        currentPage: currentPage ?? this.currentPage,
      );
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class BlogNotifier extends Notifier<BlogState> {
  @override
  BlogState build() => BlogState(articles: _buildMockArticles());

  void setSearch(String q) =>
      state = state.copyWith(searchQuery: q, currentPage: 1);

  void setCategory(String? cat) => state = state.copyWith(
        activeCategory: () => cat,
        currentPage: 1,
      );

  void setPage(int page) => state = state.copyWith(currentPage: page);
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final blogProvider = NotifierProvider<BlogNotifier, BlogState>(
  BlogNotifier.new,
);

/// Flat list of all category strings for the chip row.
const kBlogCategories = _kCategories;
```

- [ ] **Step 4: Run tests — expect PASS**

```bash
flutter test test/providers/blog_provider_test.dart
```

Expected: all 7 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/providers/blog_provider.dart test/providers/blog_provider_test.dart
git commit -m "feat(blog): add BlogState, BlogNotifier, and provider tests"
```

---

## Task 3: Localization keys

**Files:**
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_el.arb`
- Modify: `lib/l10n/app_ar.arb`

- [ ] **Step 1: Add English keys**

In `lib/l10n/app_en.arb`, replace the final `}` with:

```json
  "blogNewsTitle": "Blog & News",
  "blogNewsSubtitle": "Discover career tips, interview guides, and platform updates.",
  "blogSearchHint": "Search for articles and topics",
  "blogAllCategories": "All"
}
```

- [ ] **Step 2: Add Greek keys**

In `lib/l10n/app_el.arb`, replace the final `}` with:

```json
  "blogNewsTitle": "Blog & Νέα",
  "blogNewsSubtitle": "Ανακαλύψτε συμβουλές καριέρας, οδηγούς συνεντεύξεων και νέα της πλατφόρμας.",
  "blogSearchHint": "Αναζήτηση άρθρων και θεμάτων",
  "blogAllCategories": "Όλα"
}
```

- [ ] **Step 3: Add Arabic keys**

In `lib/l10n/app_ar.arb`, replace the final `}` with:

```json
  "blogNewsTitle": "المدونة والأخبار",
  "blogNewsSubtitle": "اكتشف نصائح مهنية وأدلة مقابلات وتحديثات المنصة.",
  "blogSearchHint": "ابحث في المقالات والمواضيع",
  "blogAllCategories": "الكل"
}
```

- [ ] **Step 4: Regenerate localization**

```bash
flutter gen-l10n
```

Expected: no errors, `lib/l10n/app_localizations*.dart` updated.

- [ ] **Step 5: Commit**

```bash
git add lib/l10n/
git commit -m "feat(blog): add localization keys for Blog & News screen"
```

---

## Task 4: Route constant

**Files:**
- Modify: `lib/routes.dart`

- [ ] **Step 1: Add `blogNews` constant**

In `lib/routes.dart`, after `static const settingsNotifications = '/settings/notifications';` add:

```dart
  // Blog
  static const blogNews = '/blog';
```

- [ ] **Step 2: Register route in router**

In `lib/router.dart`, add import at top:

```dart
import 'screens/blog/blog_news_screen.dart';
```

Then inside `routes: [...]`, after the settings routes, add:

```dart
      GoRoute(
        path: Routes.blogNews,
        builder: (context, state) => const BlogNewsScreen(),
      ),
```

- [ ] **Step 3: Commit**

```bash
git add lib/routes.dart lib/router.dart
git commit -m "feat(blog): register /blog route"
```

---

## Task 5: BlogSearchBar widget

**Files:**
- Create: `lib/screens/blog/widgets/blog_search_bar.dart`

- [ ] **Step 1: Create widget**

```dart
// lib/screens/blog/widgets/blog_search_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/blog_provider.dart';
import '../../../l10n/app_localizations.dart';

class BlogSearchBar extends ConsumerWidget {
  const BlogSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextField(
          onChanged: (q) => ref.read(blogProvider.notifier).setSearch(q),
          decoration: InputDecoration(
            hintText: l10n.blogSearchHint,
            hintStyle: const TextStyle(color: IthakiTheme.softGraphite),
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12),
              child: IthakiIcon('search', size: 20, color: IthakiTheme.lightGraphite),
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/screens/blog/widgets/blog_search_bar.dart
git commit -m "feat(blog): add BlogSearchBar widget"
```

---

## Task 6: BlogCategoryChips widget

**Files:**
- Create: `lib/screens/blog/widgets/blog_category_chips.dart`

- [ ] **Step 1: Create widget**

```dart
// lib/screens/blog/widgets/blog_category_chips.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/blog_provider.dart';
import '../../../l10n/app_localizations.dart';

class BlogCategoryChips extends ConsumerWidget {
  const BlogCategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final activeCategory = ref.watch(blogProvider).activeCategory;

    final allLabel = l10n.blogAllCategories;
    final chips = [null, ...kBlogCategories]; // null = "All"

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = chips[i];
          final label = cat ?? allLabel;
          final isActive = cat == activeCategory;
          return GestureDetector(
            onTap: () =>
                ref.read(blogProvider.notifier).setCategory(cat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? IthakiTheme.chipActive
                    : IthakiTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? IthakiTheme.primaryPurple
                      : IthakiTheme.borderLight,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? IthakiTheme.primaryPurple
                      : IthakiTheme.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/screens/blog/widgets/blog_category_chips.dart
git commit -m "feat(blog): add BlogCategoryChips widget"
```

---

## Task 7: BlogArticleCard widget

**Files:**
- Create: `lib/screens/blog/widgets/blog_article_card.dart`

- [ ] **Step 1: Create widget**

```dart
// lib/screens/blog/widgets/blog_article_card.dart
import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../models/blog_models.dart';

class BlogArticleCard extends StatelessWidget {
  final BlogArticle article;

  const BlogArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IthakiCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                article.imageAsset,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category label
                  Text(
                    article.category,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: IthakiTheme.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Title
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: IthakiTheme.headingSmall,
                  ),
                  const SizedBox(height: 6),
                  // Description
                  Text(
                    article.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: IthakiTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Author + date
                  Row(
                    children: [
                      Text(
                        article.author,
                        style: const TextStyle(
                          fontSize: 12,
                          color: IthakiTheme.textSecondary,
                          fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/screens/blog/widgets/blog_article_card.dart
git commit -m "feat(blog): add BlogArticleCard widget"
```

---

## Task 8: BlogPagination widget

**Files:**
- Create: `lib/screens/blog/widgets/blog_pagination.dart`

- [ ] **Step 1: Create widget**

```dart
// lib/screens/blog/widgets/blog_pagination.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/blog_provider.dart';

class BlogPagination extends ConsumerWidget {
  const BlogPagination({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(blogProvider);
    final total = state.totalPages;
    final current = state.currentPage;

    if (total <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(total, (i) {
            final page = i + 1;
            final isActive = page == current;
            return GestureDetector(
              onTap: () =>
                  ref.read(blogProvider.notifier).setPage(page),
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? IthakiTheme.primaryPurple
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$page',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w400,
                    color: isActive
                        ? IthakiTheme.backgroundWhite
                        : IthakiTheme.textSecondary,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/screens/blog/widgets/blog_pagination.dart
git commit -m "feat(blog): add BlogPagination widget"
```

---

## Task 9: BlogNewsScreen

**Files:**
- Create: `lib/screens/blog/blog_news_screen.dart`

- [ ] **Step 1: Create screen**

```dart
// lib/screens/blog/blog_news_screen.dart
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
```

- [ ] **Step 2: Commit**

```bash
git add lib/screens/blog/
git commit -m "feat(blog): add BlogNewsScreen"
```

---

## Task 10: Wire home "Discover All News" button

**Files:**
- Modify: `lib/screens/home/widgets/home_news_section.dart`

- [ ] **Step 1: Add GoRouter import and wire button**

In `lib/screens/home/widgets/home_news_section.dart`, add import:

```dart
import 'package:go_router/go_router.dart';
import '../../../routes.dart';
```

Then change `onPressed: () {}` on the `OutlinedButton` to:

```dart
onPressed: () => context.go(Routes.blogNews),
```

- [ ] **Step 2: Commit**

```bash
git add lib/screens/home/widgets/home_news_section.dart
git commit -m "feat(blog): wire home news section button to Blog & News screen"
```

---

## Task 11: Final build verification

- [ ] **Step 1: Run all tests**

```bash
flutter test
```

Expected: all tests PASS.

- [ ] **Step 2: Build check (no device needed)**

```bash
flutter build apk --debug --dart-define=ITHAKI_API_BASE_URL=https://api.odyssea.com/talent/staging 2>&1 | tail -5
```

Expected: `Build successful`.

# Blog & News Screen — Design Spec

**Date:** 2026-04-15  
**Status:** Approved

---

## Overview

A dedicated Blog & News screen that lists articles with category filtering, full-text search, and client-side pagination (4 articles per page). Data is mock until a real API endpoint is available.

---

## Data Model

**File:** `lib/models/blog_models.dart`

```dart
class BlogArticle {
  final String id;
  final String imageAsset;   // e.g. 'assets/images/blog_1.jpg'
  final String category;     // e.g. '#Career Tips'
  final String title;
  final String description;
  final String author;       // e.g. 'Ithaki Team'
  final String date;         // e.g. 'Today, 19:55'

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

The existing `NewsItem` model in `lib/models/home_models.dart` is unchanged.

**Mock categories:**
`#Career Tips`, `#Interviews`, `#Networking`, `#CV & Portfolio`, `#Life Resources`, `#Work Search`, `#Success Stories`

**Mock data:** 20 articles spread across all categories, using placeholder images from `assets/images/`.

---

## State Management

**File:** `lib/providers/blog_provider.dart`

```dart
class BlogState {
  final List<BlogArticle> articles;   // full list (20 mock articles)
  final String searchQuery;           // live search string
  final String? activeCategory;       // null = all categories
  final int currentPage;              // 1-indexed

  static const int pageSize = 4;

  List<BlogArticle> get filtered { ... }   // apply search + category filter
  List<BlogArticle> get paginated { ... }  // slice filtered by currentPage
  int get totalPages => (filtered.length / pageSize).ceil();
}
```

`BlogNotifier extends Notifier<BlogState>` — synchronous (local data, no async):
- `setSearch(String q)` — updates query, resets to page 1
- `setCategory(String? cat)` — updates active category, resets to page 1
- `setPage(int page)` — updates current page

Provider:
```dart
final blogProvider = NotifierProvider<BlogNotifier, BlogState>(BlogNotifier.new);
```

---

## Screen Structure

**File:** `lib/screens/blog/blog_news_screen.dart`

Pattern: `ConsumerStatefulWidget` + `PanelMenuController` + `IthakiAppBar` + `SingleChildScrollView` — identical to `JobSearchScreen`.

Layout (top to bottom):
1. `IthakiAppBar` (menu + avatar)
2. Screen title "Blog & News" (`IthakiTheme.headingLarge`)
3. Subtitle (`IthakiTheme.bodyMedium`, `textSecondary`)
4. `BlogSearchBar` — search input
5. `BlogCategoryChips` — horizontal scroll of category chips
6. List of `BlogArticleCard` (4 per page)
7. `BlogPagination` — numbered page buttons
8. `IthakiGradientBanner` — "Not sure how to find the right job? / Ask Career Assistant"
9. `IthakiFooter`

---

## Widgets

### `lib/screens/blog/widgets/blog_search_bar.dart`
- Reads/writes `blogProvider` via `ref.read(...).setSearch(...)`
- Uses `TextField` styled consistently with `JobSearchSearchBar`
- Placeholder: `AppLocalizations.of(context)!.blogSearchHint`

### `lib/screens/blog/widgets/blog_category_chips.dart`
- Horizontal `SingleChildScrollView` of `OptionChip` widgets
- First chip: "All" (selects `activeCategory = null`)
- Remaining: one per category string
- Active chip highlighted via `IthakiTheme.chipActive`

### `lib/screens/blog/widgets/blog_article_card.dart`
- `IthakiCard` wrapper
- Top: `ClipRRect` with `Image.asset` (height 180, `BoxFit.cover`)
- Body padding 16px:
  - Category chip label (`IthakiTheme.textSecondary`, small)
  - Title (`IthakiTheme.headingSmall`, max 2 lines)
  - Description (`IthakiTheme.bodyMedium`, `textSecondary`, max 2 lines)
  - Row: author + spacer + date (both `textSecondary`, size 12)

### `lib/screens/blog/widgets/blog_pagination.dart`
- Row of `TextButton`s, one per page
- Active page: `IthakiTheme.primaryPurple` text + bold
- Inactive pages: `IthakiTheme.textSecondary`
- Calls `ref.read(blogProvider.notifier).setPage(n)`

---

## Routing

**`lib/routes.dart`:** add `static const blogNews = '/blog';`

**`lib/router.dart`:** add `GoRoute(path: Routes.blogNews, builder: (_, __) => const BlogNewsScreen())`

**Nav items:** wire "Blog" nav item (already in `kAppNavItems`) to `Routes.blogNews`.

---

## Localization

New keys added to `app_en.arb`, `app_el.arb`, `app_ar.arb`:

| Key | EN |
|-----|----|
| `blogNewsTitle` | Blog & News |
| `blogNewsSubtitle` | Discover career tips, interview guides, and platform updates. |
| `blogSearchHint` | Search for articles and topics |
| `blogAllCategories` | All |

---

## Out of Scope

- Real API integration (no `/api/blog` endpoint exists yet)
- Article detail screen
- Bookmarking / saving articles

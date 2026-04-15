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

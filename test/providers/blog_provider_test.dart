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

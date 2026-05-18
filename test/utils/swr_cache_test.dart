import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/utils/swr_cache.dart';

void main() {
  test('deduplicates concurrent initial loads', () async {
    final cache = SwrCache();
    var calls = 0;
    final completer = Completer<int>();

    final first = cache.getOrRefresh<int>(
      key: 'item',
      ttl: const Duration(minutes: 1),
      load: () {
        calls++;
        return completer.future;
      },
    );
    final second = cache.getOrRefresh<int>(
      key: 'item',
      ttl: const Duration(minutes: 1),
      load: () {
        calls++;
        return Future.value(2);
      },
    );

    completer.complete(1);

    expect(await first, 1);
    expect(await second, 1);
    expect(calls, 1);
  });

  test('returns stale data immediately and refreshes in the background',
      () async {
    var now = DateTime(2026, 5, 18, 10);
    final cache = SwrCache(now: () => now);

    await cache.getOrRefresh<int>(
      key: 'item',
      ttl: const Duration(minutes: 1),
      load: () async => 1,
    );

    now = now.add(const Duration(minutes: 2));
    final refreshCompleter = Completer<int>();
    int? refreshed;

    final stale = await cache.getOrRefresh<int>(
      key: 'item',
      ttl: const Duration(minutes: 1),
      load: () => refreshCompleter.future,
      onData: (data) => refreshed = data,
    );

    expect(stale, 1);
    expect(refreshed, isNull);

    refreshCompleter.complete(2);
    await refreshCompleter.future;
    await Future<void>.delayed(Duration.zero);

    expect(refreshed, 2);
    expect(cache.peek<int>('item'), 2);
  });

  test('refresh can preserve stale data when the loader fails', () async {
    final cache = SwrCache();
    await cache.getOrRefresh<int>(
      key: 'item',
      ttl: const Duration(minutes: 1),
      load: () async => 1,
    );

    final value = await cache.refresh<int>(
      key: 'item',
      allowStaleOnError: true,
      load: () async => throw StateError('network failed'),
    );

    expect(value, 1);
    expect(cache.peek<int>('item'), 1);
    expect(cache.lastError('item'), isA<StateError>());
  });
}

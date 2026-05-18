import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/swr_cache.dart';

final swrCacheProvider = Provider<SwrCache>((_) => SwrCache());

abstract class SwrAsyncNotifier<T> extends AsyncNotifier<T> {
  String get cacheKey;

  Duration get cacheTtl => const Duration(minutes: 5);

  Future<T> load();

  @override
  Future<T> build() {
    final cache = ref.read(swrCacheProvider);
    return cache.getOrRefresh<T>(
      key: cacheKey,
      ttl: cacheTtl,
      load: load,
      onData: (data) {
        if (ref.mounted) state = AsyncData(data);
      },
      onError: (error, stackTrace, hasStaleData) {
        if (ref.mounted && !hasStaleData) {
          state = AsyncError(error, stackTrace);
        }
      },
    );
  }

  Future<void> refresh({bool force = true}) async {
    final hadPrevious = state.hasValue;
    final previous = state.value;
    if (!hadPrevious) {
      state = const AsyncLoading();
    }

    try {
      final cache = ref.read(swrCacheProvider);
      final data = force
          ? await cache.refresh<T>(
              key: cacheKey,
              load: load,
              allowStaleOnError: hadPrevious || cache.hasData(cacheKey),
            )
          : await cache.getOrRefresh<T>(
              key: cacheKey,
              ttl: cacheTtl,
              load: load,
            );
      if (ref.mounted) state = AsyncData(data);
    } catch (error, stackTrace) {
      if (!ref.mounted) return;
      if (hadPrevious) {
        state = AsyncData(previous as T);
      } else {
        state = AsyncError(error, stackTrace);
      }
    }
  }

  void cacheValue(T value) {
    ref.read(swrCacheProvider).set<T>(cacheKey, value);
  }

  void invalidateCache() {
    ref.read(swrCacheProvider).invalidate(cacheKey);
  }
}

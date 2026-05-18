import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../repositories/home_repository.dart';
import '../services/api_client.dart';
import 'profile_provider.dart';
import 'swr_async_notifier.dart';

export '../repositories/home_repository.dart' show HomeData;

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => AppConfig.useMockData
      ? MockHomeRepository()
      : ApiHomeRepository(apiClient: ref.watch(apiClientProvider)),
);

class HomeNotifier extends SwrAsyncNotifier<HomeData> {
  @override
  String get cacheKey => 'home';

  @override
  Future<HomeData> load() => ref.read(homeRepositoryProvider).getData();

  @override
  Future<HomeData> build() async {
    final cache = ref.read(swrCacheProvider);
    final data = await cache.getOrRefresh<HomeData>(
      key: cacheKey,
      ttl: cacheTtl,
      load: load,
      onData: (fresh) {
        if (ref.mounted) {
          final latestBasics = _profileBasicsOrNull(watch: false);
          state = AsyncData(_withProfileBasics(fresh, latestBasics));
        }
      },
      onError: (error, stackTrace, hasStaleData) {
        if (ref.mounted && !hasStaleData) {
          state = AsyncError(error, stackTrace);
        }
      },
    );
    final basics = _profileBasicsOrNull();

    return _withProfileBasics(data, basics);
  }

  @override
  Future<void> refresh({bool force = true}) async {
    await super.refresh(force: force);
    final data = state.value;
    if (data != null) {
      state = AsyncData(
        _withProfileBasics(data, _profileBasicsOrNull(watch: false)),
      );
    }
  }

  ProfileBasics? _profileBasicsOrNull({bool watch = true}) {
    if (!ref.exists(profileBasicsProvider) &&
        !AppConfig.shouldUseMockData &&
        AppConfig.apiBaseUrl.isEmpty) {
      return null;
    }
    try {
      final basics = watch
          ? ref.watch(profileBasicsProvider)
          : ref.read(profileBasicsProvider);
      return basics.value;
    } catch (_) {
      return null;
    }
  }

  HomeData _withProfileBasics(HomeData data, ProfileBasics? basics) {
    if (basics == null || basics.firstName.isEmpty) return data;

    return HomeData(
      userName: basics.firstName,
      userInitials: basics.initials,
      userPhotoUrl: basics.photoUrl,
      cvStats: data.cvStats,
      jobs: data.jobs,
      courses: data.courses,
      news: data.news,
      isNewUser: data.isNewUser,
      profileItems: data.profileItems,
      profileBenefits: data.profileBenefits,
      filterChips: data.filterChips,
    );
  }
}

final homeProvider = AsyncNotifierProvider<HomeNotifier, HomeData>(
  HomeNotifier.new,
);

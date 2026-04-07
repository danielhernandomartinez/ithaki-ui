import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/home_repository.dart';
import 'profile_provider.dart';

export '../repositories/home_repository.dart' show HomeData;

class HomeNotifier extends AsyncNotifier<HomeData> {
  @override
  Future<HomeData> build() async {
    final data = await ref.read(homeRepositoryProvider).getData();
    final basics = ref.watch(profileBasicsProvider).value;

    if (basics == null || basics.firstName.isEmpty) return data;

    return HomeData(
      userName: basics.firstName,
      userInitials: basics.initials,
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

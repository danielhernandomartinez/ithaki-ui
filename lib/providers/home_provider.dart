import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/home_repository.dart';

export '../repositories/home_repository.dart' show HomeData;

class HomeNotifier extends AsyncNotifier<HomeData> {
  @override
  Future<HomeData> build() =>
      ref.read(homeRepositoryProvider).getData();
}

final homeProvider = AsyncNotifierProvider<HomeNotifier, HomeData>(
  HomeNotifier.new,
);

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../repositories/city_search_repository.dart';
import '../services/api_client.dart';

export '../repositories/city_search_repository.dart'
    show CityResult, CitySearchRepository;

final citySearchRepositoryProvider = Provider<CitySearchRepository>(
  (ref) => AppConfig.useMockData
      ? MockCitySearchRepository()
      : ApiCitySearchRepository(ref.watch(apiClientProvider)),
);

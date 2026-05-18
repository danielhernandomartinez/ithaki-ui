import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../repositories/auth_repository.dart';
import '../services/api_client.dart';
import '../services/session_service.dart';

export '../repositories/auth_repository.dart'
    show AuthException, AuthRepository, LoginSession, MockAuthRepository;

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AppConfig.useMockData
      ? MockAuthRepository(sessionService: ref.watch(sessionServiceProvider))
      : ApiAuthRepository(
          apiClient: ref.watch(apiClientProvider),
          sessionService: ref.watch(sessionServiceProvider),
        ),
);

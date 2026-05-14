import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/api_diagnostics_repository.dart';
import '../services/api_client.dart';

final apiDiagnosticsRepositoryProvider = Provider<ApiDiagnosticsRepository>(
  (ref) => ApiDiagnosticsRepository(
    apiClient: ref.watch(apiClientProvider),
  ),
);

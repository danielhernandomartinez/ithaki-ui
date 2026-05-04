import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_client.dart';

class ApiDiagnosticEndpoint {
  const ApiDiagnosticEndpoint({
    required this.id,
    required this.title,
    required this.path,
    this.params = const {},
    this.requiresAuth = false,
    this.notes = '',
  });

  final String id;
  final String title;
  final String path;
  final Map<String, String> params;
  final bool requiresAuth;
  final String notes;

  String get displayPath {
    if (params.isEmpty) return path;
    final query = Uri(queryParameters: params).query;
    return '$path?$query';
  }
}

class ApiDiagnosticResult {
  const ApiDiagnosticResult({
    required this.endpoint,
    required this.duration,
    this.statusCode,
    this.error,
    this.responsePreview = '',
  });

  final ApiDiagnosticEndpoint endpoint;
  final Duration duration;
  final int? statusCode;
  final String? error;
  final String responsePreview;

  bool get hasError =>
      error != null || statusCode == null || statusCode! < 200 || statusCode! >= 300;

  String get statusLabel => statusCode?.toString() ?? 'ERR';
}

class ApiDiagnosticsRepository {
  ApiDiagnosticsRepository({
    required ApiClient apiClient,
    this.timeout = const Duration(seconds: 12),
  }) : _api = apiClient;

  final ApiClient _api;
  final Duration timeout;

  static const endpoints = [
    ApiDiagnosticEndpoint(
      id: 'jobs',
      title: 'Job search',
      path: '/jobs',
      params: {'page': '0', 'size': '10'},
    ),
    ApiDiagnosticEndpoint(
      id: 'job-detail',
      title: 'Job detail',
      path: '/jobs/job-1',
    ),
    ApiDiagnosticEndpoint(
      id: 'company',
      title: 'Company profile',
      path: '/companies/company-1',
    ),
    ApiDiagnosticEndpoint(
      id: 'city',
      title: 'City search',
      path: '/city',
      params: {'name': 'Athens', 'page': '0', 'size': '20'},
    ),
    ApiDiagnosticEndpoint(
      id: 'skills-hard',
      title: 'Hard skills',
      path: '/skills/hard',
    ),
    ApiDiagnosticEndpoint(
      id: 'skills-soft',
      title: 'Soft skills',
      path: '/skills/soft',
    ),
    ApiDiagnosticEndpoint(
      id: 'languages',
      title: 'Languages',
      path: '/list/languages',
    ),
    ApiDiagnosticEndpoint(
      id: 'personality-values',
      title: 'Personality values',
      path: '/list/personality-values',
    ),
    ApiDiagnosticEndpoint(
      id: 'job-interests',
      title: 'Job interests',
      path: '/list/job-interests',
    ),
    ApiDiagnosticEndpoint(
      id: 'user-me',
      title: 'Current user',
      path: '/user/me',
      requiresAuth: true,
    ),
    ApiDiagnosticEndpoint(
      id: 'job-seeker-me',
      title: 'Job seeker profile',
      path: '/job-seeker/me',
      requiresAuth: true,
    ),
    ApiDiagnosticEndpoint(
      id: 'applications',
      title: 'Applications',
      path: '/job-seeker/me/applications',
      requiresAuth: true,
    ),
    ApiDiagnosticEndpoint(
      id: 'invitations',
      title: 'Invitations',
      path: '/job-seeker/me/invitations',
      requiresAuth: true,
    ),
  ];

  Future<ApiDiagnosticResult> runEndpoint(
    ApiDiagnosticEndpoint endpoint,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      final token = await _api.readTokenOrNull();
      final response = await _api.client
          .get(
            _api.uri(endpoint.path, endpoint.params),
            headers: {
              'Accept': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(timeout);
      stopwatch.stop();
      return ApiDiagnosticResult(
        endpoint: endpoint,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        responsePreview: _preview(response.body),
      );
    } catch (error) {
      stopwatch.stop();
      return ApiDiagnosticResult(
        endpoint: endpoint,
        duration: stopwatch.elapsed,
        error: error.toString(),
      );
    }
  }

  Future<List<ApiDiagnosticResult>> runAll() async {
    final results = <ApiDiagnosticResult>[];
    for (final endpoint in endpoints) {
      results.add(await runEndpoint(endpoint));
    }
    return results;
  }

  String _preview(String body) {
    final normalized = body.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.length <= 220) return normalized;
    return '${normalized.substring(0, 220)}...';
  }
}

final apiDiagnosticsRepositoryProvider = Provider<ApiDiagnosticsRepository>(
  (ref) => ApiDiagnosticsRepository(
    apiClient: ref.watch(apiClientProvider),
  ),
);

import 'package:flutter/foundation.dart';

import '../../models/profile_models.dart';
import '../../services/api_client.dart';
import '../../utils/parse_utils.dart';
import 'profile_response_parser.dart';

class ProfileDocumentsService {
  ProfileDocumentsService(this._api);

  final ApiClient _api;

  Future<List<UploadedFile>> fetchRemoteDocuments() {
    return ProfileResponseParser.fetchRemoteDocuments(_api);
  }

  Future<List<UploadedFile>> saveFiles({
    required List<UploadedFile> incoming,
    required List<UploadedFile> current,
  }) async {
    final incomingIds = incoming
        .where((file) => file.id != null)
        .map((file) => file.id)
        .toSet();
    final removedIds = current
        .where((file) => file.id != null && !incomingIds.contains(file.id))
        .map((file) => file.id!)
        .toList();

    for (final id in removedIds) {
      _debugLog('[saveFiles] deleting remote document id=$id');
      final response = await _api.delete('/files/me/documents/$id');
      _debugLog('[saveFiles] delete response status -> ${response.statusCode}');
      _debugLog('[saveFiles] delete response body -> ${response.body}');
    }

    final localFiles = incoming
        .where((file) =>
            file.id == null && ProfileResponseParser.isLocalFilePath(file.url))
        .toList();
    final localPaths = localFiles
        .map((file) => ProfileResponseParser.localFilePath(file.url))
        .whereType<String>()
        .toList();
    if (localPaths.isNotEmpty) {
      _debugLog('[saveFiles] uploading ${localPaths.length} document(s)');
      for (final file in localFiles) {
        _debugLog('[saveFiles] upload candidate -> ${file.name} | ${file.url}');
      }
      final response = await _api.uploadMultipartFiles(
        '/files/me/upload/documents',
        'uploadedFiles',
        localPaths,
      );
      _debugLog('[saveFiles] upload response status -> ${response.statusCode}');
      _debugLog('[saveFiles] upload response body -> ${response.body}');
    }

    final unsupported = incoming.where(
      (file) =>
          file.id == null && !ProfileResponseParser.isLocalFilePath(file.url),
    );
    for (final file in unsupported) {
      _debugLog(
        '[saveFiles] skipped unsupported document source -> ${file.name} | ${file.url}',
      );
    }

    try {
      return await fetchRemoteDocuments();
    } catch (e) {
      _debugLog('[saveFiles] remote refresh failed -> $e');
      return incoming;
    }
  }

  Future<Uint8List> downloadFile(UploadedFile file) async {
    final id = file.id;
    final url = file.url;
    _debugLog(
      '[downloadFile] requested -> id=${file.id}, name=${file.name}, url=${url ?? '<none>'}',
    );

    if (id != null) {
      _debugLog('[downloadFile] using document id endpoint -> $id');
      final res = await _api.get(
        '/files/me/documents/$id/download',
        timeout: ApiClient.uploadTimeout,
      );
      _debugLog('[downloadFile] id endpoint status -> ${res.statusCode}');
      if (res.statusCode == 200) return res.bodyBytes;
      if (url == null) {
        throw Exception('Download failed: HTTP ${res.statusCode}');
      }
      _debugLog('[downloadFile] id endpoint failed, trying url fallback');
    }

    if (url != null) {
      final uri = trimmedUri(url);
      if (isHttpUrl(url) && uri != null) {
        _debugLog('[downloadFile] trying remote url -> $url');
        final apiHost = Uri.parse(_api.base).host;
        final isSameOrigin = uri.host == apiHost;
        final headers = isSameOrigin
            ? {'Authorization': 'Bearer ${await _api.requireToken()}'}
            : <String, String>{};
        final res = await _api.client
            .get(uri, headers: headers)
            .timeout(ApiClient.uploadTimeout);
        _debugLog('[downloadFile] remote url status -> ${res.statusCode}');
        if (res.statusCode == 200) return res.bodyBytes;
      } else {
        _debugLog(
            '[downloadFile] url is not http(s), skipping direct download');
      }
    }

    throw Exception('No download source for: ${file.name}');
  }

  static void _debugLog(String message) {
    if (kDebugMode) debugPrint(message);
  }
}

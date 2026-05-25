import 'dart:convert';

Map<String, dynamic>? decodeJwtPayload(String jwt) {
  final parts = jwt.split('.');
  if (parts.length < 2) return null;

  try {
    final normalized = base64Url.normalize(parts[1]);
    final payloadBytes = base64Url.decode(normalized);
    final payloadString = utf8.decode(payloadBytes);
    final decoded = jsonDecode(payloadString);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return decoded.cast<String, dynamic>();
    return null;
  } catch (_) {
    return null;
  }
}


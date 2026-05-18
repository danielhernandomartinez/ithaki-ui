import 'dart:async';

class SwrCache {
  SwrCache({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  final Map<String, _SwrCacheEntry> _entries = {};

  bool hasData(String key) => _entries[key]?.hasData ?? false;

  T? peek<T>(String key) {
    final entry = _entries[key];
    if (entry == null || !entry.hasData) return null;
    return entry.data as T;
  }

  Object? lastError(String key) => _entries[key]?.error;

  Future<T> getOrRefresh<T>({
    required String key,
    required Future<T> Function() load,
    required Duration ttl,
    void Function(T data)? onData,
    void Function(Object error, StackTrace stackTrace, bool hasStaleData)?
        onError,
  }) {
    final entry = _entries[key];
    if (entry != null && entry.hasData) {
      if (_isStale(entry, ttl)) {
        unawaited(
          refresh<T>(
            key: key,
            load: load,
            allowStaleOnError: true,
            onData: onData,
            onError: onError,
          ),
        );
      }
      return Future<T>.value(entry.data as T);
    }

    return refresh<T>(
      key: key,
      load: load,
      allowStaleOnError: false,
      onData: onData,
      onError: onError,
    );
  }

  Future<T> refresh<T>({
    required String key,
    required Future<T> Function() load,
    bool allowStaleOnError = true,
    void Function(T data)? onData,
    void Function(Object error, StackTrace stackTrace, bool hasStaleData)?
        onError,
  }) {
    final entry = _entries.putIfAbsent(key, _SwrCacheEntry.new);
    final inFlight = entry.inFlight;
    if (inFlight != null) return inFlight as Future<T>;

    final future = load().then((data) {
      entry
        ..data = data
        ..hasData = true
        ..updatedAt = _now()
        ..error = null
        ..stackTrace = null;
      onData?.call(data);
      return data;
    }).catchError((Object error, StackTrace stackTrace) {
      entry
        ..error = error
        ..stackTrace = stackTrace;
      onError?.call(error, stackTrace, entry.hasData);
      if (allowStaleOnError && entry.hasData) {
        return entry.data as T;
      }
      Error.throwWithStackTrace(error, stackTrace);
    });

    entry.inFlight = future;
    unawaited(future.whenComplete(() {
      if (identical(entry.inFlight, future)) {
        entry.inFlight = null;
      }
    }));

    return future;
  }

  void set<T>(String key, T data) {
    final entry = _entries.putIfAbsent(key, _SwrCacheEntry.new);
    entry
      ..data = data
      ..hasData = true
      ..updatedAt = _now()
      ..error = null
      ..stackTrace = null;
  }

  void invalidate(String key) {
    _entries.remove(key);
  }

  void invalidatePrefix(String prefix) {
    _entries.removeWhere((key, _) => key.startsWith(prefix));
  }

  void clear() {
    _entries.clear();
  }

  bool _isStale(_SwrCacheEntry entry, Duration ttl) {
    final updatedAt = entry.updatedAt;
    if (updatedAt == null) return true;
    return _now().difference(updatedAt) >= ttl;
  }
}

class _SwrCacheEntry {
  Object? data;
  bool hasData = false;
  DateTime? updatedAt;
  Object? error;
  StackTrace? stackTrace;
  Future<Object?>? inFlight;
}

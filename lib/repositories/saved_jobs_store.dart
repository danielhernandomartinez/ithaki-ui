import 'package:shared_preferences/shared_preferences.dart';

class SavedJobsStore {
  static const _key = 'ithaki_saved_job_ids';

  const SavedJobsStore();

  Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? const <String>[]).toSet();
  }

  Future<void> save(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final sorted = ids.toList()..sort();
    await prefs.setStringList(_key, sorted);
  }
}

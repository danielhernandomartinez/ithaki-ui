import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kFillProfileDone = 'fill_profile_done';

class FillProfileNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kFillProfileDone) ?? false;
  }

  Future<void> markDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kFillProfileDone, true);
    state = const AsyncData(true);
  }
}

final fillProfileDoneProvider =
    AsyncNotifierProvider<FillProfileNotifier, bool>(FillProfileNotifier.new);

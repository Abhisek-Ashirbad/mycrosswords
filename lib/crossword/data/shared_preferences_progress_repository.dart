import 'package:shared_preferences/shared_preferences.dart';

import 'progress_repository.dart';

class SharedPreferencesProgressRepository implements ProgressRepository {
  SharedPreferencesProgressRepository(this._preferences);

  static const _progressKey = 'crossword_progress';

  final SharedPreferences _preferences;

  @override
  Future<String?> loadProgress() async => _preferences.getString(_progressKey);

  @override
  Future<void> saveProgress(String progress) async {
    final saved = await _preferences.setString(_progressKey, progress);
    if (!saved) {
      throw Exception('The device did not save crossword progress.');
    }
  }
}

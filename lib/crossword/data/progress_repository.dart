abstract interface class ProgressRepository {
  Future<String?> loadProgress();

  Future<void> saveProgress(String progress);
}

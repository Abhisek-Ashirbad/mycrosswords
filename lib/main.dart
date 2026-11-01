import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'crossword/data/daily_puzzle.dart';
import 'crossword/data/progress_repository.dart';
import 'crossword/data/shared_preferences_progress_repository.dart';
import 'crossword/state/crossword_controller.dart';
import 'crossword/ui/crossword_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final repository = SharedPreferencesProgressRepository(preferences);
  final controller = CrosswordController(
    puzzle: dailyPuzzle,
    progressRepository: repository,
  );
  await controller.restoreProgress();
  runApp(CrosswordApp(controller: controller));
}

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mycrosswords/crossword/data/daily_puzzle.dart';
import 'package:mycrosswords/crossword/data/progress_repository.dart';
import 'package:mycrosswords/crossword/state/crossword_controller.dart';
import 'package:mycrosswords/crossword/ui/crossword_app.dart';

class _InMemoryProgressRepository implements ProgressRepository {
  String? savedProgress;

  @override
  Future<String?> loadProgress() async => savedProgress;

  @override
  Future<void> saveProgress(String progress) async {
    savedProgress = progress;
  }
}

void main() {
  late _InMemoryProgressRepository repository;
  late CrosswordController controller;

  Future<void> givenANewGame(WidgetTester tester) async {
    repository = _InMemoryProgressRepository();
    controller = CrosswordController(
      puzzle: dailyPuzzle,
      progressRepository: repository,
    );
    await controller.restoreProgress();
    await tester.pumpWidget(CrosswordApp(controller: controller));
  }

  Future<void> whenIEnterWord(
    WidgetTester tester,
    int clueNumber,
    String answer,
  ) async {
    final clue = find.byKey(
      ValueKey('clue-across-$clueNumber'),
    );
    await tester.ensureVisible(clue);
    await tester.tap(clue);
    await tester.pump();
    for (final letter in answer.split('')) {
      final key = find.byKey(ValueKey('letter-$letter'));
      await tester.ensureVisible(key);
      await tester.tap(key);
      await tester.pump();
    }
  }

  testWidgets(
    'Given an empty puzzle, when all Across words are entered, '
    'then the correct completed puzzle is celebrated and saved',
    (tester) async {
      await givenANewGame(tester);

      await whenIEnterWord(tester, 1, 'BALL');
      await whenIEnterWord(tester, 2, 'AREA');
      await whenIEnterWord(tester, 3, 'LEAD');
      await whenIEnterWord(tester, 4, 'LADY');

      final checkButton = find.byKey(const ValueKey('check-answers'));
      await tester.ensureVisible(checkButton);
      await tester.tap(checkButton);
      await tester.pump();

      expect(find.text('You solved it! Great work!'), findsOneWidget);
      expect(repository.savedProgress, 'BALLARELEADLADY');
    },
  );

  testWidgets(
    'Given a selected square, when it is tapped again, '
    'then the active clue changes from Across to Down',
    (tester) async {
      await givenANewGame(tester);

      final firstCell = find.byKey(const ValueKey('cell-0-0'));
      await tester.tap(firstCell);
      await tester.pump();
      await tester.tap(firstCell);
      await tester.pump();

      expect(find.text('Down 1   Sphere used in games'), findsOneWidget);
    },
  );

  testWidgets(
    'Given a focused square on Android TV, when the player presses right, '
    'then the selection moves to the next square',
    (tester) async {
      await givenANewGame(tester);

      await tester.tap(find.byKey(const ValueKey('cell-0-0')));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();

      expect(controller.selectedRow, 0);
      expect(controller.selectedColumn, 1);
    },
  );

  testWidgets(
    'Given an incomplete puzzle, when answers are checked, '
    'then the player is told that squares remain',
    (tester) async {
      await givenANewGame(tester);

      final checkButton = find.byKey(const ValueKey('check-answers'));
      await tester.ensureVisible(checkButton);
      await tester.tap(checkButton);
      await tester.pump();

      expect(find.text('A few squares are still empty.'), findsOneWidget);
    },
  );

  testWidgets(
    'Given saved progress, when a new game is opened, '
    'then the letters are restored',
    (tester) async {
      repository = _InMemoryProgressRepository()
        ..savedProgress = 'BALL............';
      controller = CrosswordController(
        puzzle: dailyPuzzle,
        progressRepository: repository,
      );
      await controller.restoreProgress();
      await tester.pumpWidget(CrosswordApp(controller: controller));

      expect(controller.letterAt(0, 0), 'B');
      expect(controller.letterAt(0, 1), 'A');
      expect(controller.letterAt(0, 2), 'L');
      expect(controller.letterAt(0, 3), 'L');
    },
  );
}

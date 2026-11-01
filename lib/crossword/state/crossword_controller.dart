import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/progress_repository.dart';
import '../models/crossword_puzzle.dart';

class CrosswordController extends ChangeNotifier {
  CrosswordController({
    required this.puzzle,
    required ProgressRepository progressRepository,
  }) : _progressRepository = progressRepository,
       _letters = List.generate(
         puzzle.size,
         (_) => List.filled(puzzle.size, ''),
       );

  final CrosswordPuzzle puzzle;
  final ProgressRepository _progressRepository;
  final List<List<String>> _letters;

  int selectedRow = 0;
  int selectedColumn = 0;
  CrosswordDirection direction = CrosswordDirection.across;
  String message = 'Choose a square and fill in the words.';
  int? _lastTappedCell;

  String letterAt(int row, int column) => _letters[row][column];

  Future<void> restoreProgress() async {
    final saved = await _progressRepository.loadProgress();
    if (saved == null || saved.length != puzzle.size * puzzle.size) return;

    for (var index = 0; index < saved.length; index++) {
      final value = saved[index];
      _letters[index ~/ puzzle.size][index % puzzle.size] =
          value == '.' ? '' : value;
    }
  }

  void selectCell(int row, int column, {bool toggleOnReselect = false}) {
    final isReselected = selectedRow == row && selectedColumn == column;
    selectedRow = row;
    selectedColumn = column;
    if (toggleOnReselect && isReselected) _toggleDirection();
    notifyListeners();
  }

  void selectClue(CrosswordDirection clueDirection, int index) {
    _lastTappedCell = null;
    direction = clueDirection;
    selectedRow = clueDirection == CrosswordDirection.across ? index : 0;
    selectedColumn = clueDirection == CrosswordDirection.down ? index : 0;
    notifyListeners();
  }

  void toggleDirection() {
    _lastTappedCell = null;
    _toggleDirection();
    notifyListeners();
  }

  void tapCell(int row, int column) {
    final cellIndex = row * puzzle.size + column;
    final toggle = _lastTappedCell == cellIndex;
    _lastTappedCell = cellIndex;
    selectCell(row, column, toggleOnReselect: toggle);
  }

  void _toggleDirection() {
    direction = direction == CrosswordDirection.across
        ? CrosswordDirection.down
        : CrosswordDirection.across;
  }

  bool moveSelection(int rowDelta, int columnDelta) {
    _lastTappedCell = null;
    final nextRow = selectedRow + rowDelta;
    final nextColumn = selectedColumn + columnDelta;
    if (nextRow < 0 ||
        nextRow >= puzzle.size ||
        nextColumn < 0 ||
        nextColumn >= puzzle.size) {
      return false;
    }

    selectedRow = nextRow;
    selectedColumn = nextColumn;
    if (rowDelta != 0) direction = CrosswordDirection.down;
    if (columnDelta != 0) direction = CrosswordDirection.across;
    notifyListeners();
    return true;
  }

  void enterLetter(String letter) {
    if (letter.length != 1 || !RegExp(r'^[A-Za-z]$').hasMatch(letter)) return;
    _lastTappedCell = null;
    _letters[selectedRow][selectedColumn] = letter.toUpperCase();
    message = 'Letter added. Keep going!';
    if (direction == CrosswordDirection.across) {
      selectedColumn = (selectedColumn + 1) % puzzle.size;
    } else {
      selectedRow = (selectedRow + 1) % puzzle.size;
    }
    notifyListeners();
    unawaited(_saveProgress());
  }

  void eraseLetter() {
    _lastTappedCell = null;
    _letters[selectedRow][selectedColumn] = '';
    message = 'Letter erased.';
    notifyListeners();
    unawaited(_saveProgress());
  }

  void checkAnswers() {
    var complete = true;
    var correct = true;
    for (var row = 0; row < puzzle.size; row++) {
      for (var column = 0; column < puzzle.size; column++) {
        final letter = _letters[row][column];
        if (letter.isEmpty) complete = false;
        if (letter != puzzle.solutionLetter(row, column)) correct = false;
      }
    }
    message = !complete
        ? 'A few squares are still empty.'
        : correct
        ? 'You solved it! Great work!'
        : 'Not quite yet. Check the clues and try again.';
    notifyListeners();
  }

  void clearAnswers() {
    for (final row in _letters) {
      row.fillRange(0, row.length, '');
    }
    message = 'Puzzle cleared. Start fresh!';
    notifyListeners();
    unawaited(_saveProgress());
  }

  String _serializeProgress() =>
      _letters
          .map((row) => row.map((letter) => letter.isEmpty ? '.' : letter).join())
          .join();

  Future<void> _saveProgress() async {
    try {
      await _progressRepository.saveProgress(_serializeProgress());
    } on Exception catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'crossword progress',
          context: ErrorDescription('while saving crossword progress'),
        ),
      );
      message = 'Progress could not be saved.';
      notifyListeners();
    }
  }
}

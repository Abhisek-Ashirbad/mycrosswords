enum CrosswordDirection { across, down }

class CrosswordClue {
  const CrosswordClue({required this.text, required this.answer});

  final String text;
  final String answer;
}

class CrosswordPuzzle {
  CrosswordPuzzle({
    required this.title,
    required List<CrosswordClue> across,
    required List<CrosswordClue> down,
  })  : across = List.unmodifiable(across),
        down = List.unmodifiable(down) {
    if (this.across.isEmpty ||
        this.across.any((clue) => clue.answer.length != this.across.length) ||
        this.down.length != this.across.length ||
        this.down.any((clue) => clue.answer.length != this.across.length)) {
      throw ArgumentError('The puzzle must be a square word grid.');
    }

    for (var row = 0; row < size; row++) {
      for (var column = 0; column < size; column++) {
        if (this.across[row].answer[column] !=
            this.down[column].answer[row]) {
          throw ArgumentError('Across and down answers must intersect.');
        }
      }
    }
  }

  final String title;
  final List<CrosswordClue> across;
  final List<CrosswordClue> down;

  int get size => across.length;

  CrosswordClue clue(CrosswordDirection direction, int index) =>
      direction == CrosswordDirection.across ? across[index] : down[index];

  String solutionLetter(int row, int column) => across[row].answer[column];
}

import '../models/crossword_puzzle.dart';

final dailyPuzzle = CrosswordPuzzle(
  title: 'A little puzzle for your day',
  across: const [
    CrosswordClue(text: 'Sphere used in games', answer: 'BALL'),
    CrosswordClue(text: 'A region or space', answer: 'AREA'),
    CrosswordClue(text: 'Guide or go first', answer: 'LEAD'),
    CrosswordClue(text: 'A woman', answer: 'LADY'),
  ],
  down: const [
    CrosswordClue(text: 'Sphere used in games', answer: 'BALL'),
    CrosswordClue(text: 'A region or space', answer: 'AREA'),
    CrosswordClue(text: 'Guide or go first', answer: 'LEAD'),
    CrosswordClue(text: 'A woman', answer: 'LADY'),
  ],
);

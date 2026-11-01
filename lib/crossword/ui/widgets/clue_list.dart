import 'package:flutter/material.dart';

import '../../models/crossword_puzzle.dart';
import '../../state/crossword_controller.dart';

class ClueList extends StatelessWidget {
  const ClueList({
    required this.controller,
    required this.direction,
    super.key,
  });

  final CrosswordController controller;
  final CrosswordDirection direction;

  @override
  Widget build(BuildContext context) {
    final label = direction == CrosswordDirection.across ? 'ACROSS' : 'DOWN';
    final clues = direction == CrosswordDirection.across
        ? controller.puzzle.across
        : controller.puzzle.down;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF315C4B),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        for (var index = 0; index < clues.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                key: ValueKey(
                  'clue-${direction.name}-${index + 1}',
                ),
                borderRadius: BorderRadius.circular(10),
                onTap: () => controller.selectClue(direction, index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  child: Text(
                    '${index + 1}.  ${clues[index].text}',
                    style: const TextStyle(
                      color: Color(0xFF203029),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

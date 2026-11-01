import 'package:flutter/material.dart';

import '../../models/crossword_puzzle.dart';
import '../../state/crossword_controller.dart';
import '../widgets/clue_list.dart';
import '../widgets/crossword_grid.dart';
import '../widgets/letter_keyboard.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({required this.controller, super.key});

  final CrosswordController controller;

  static const _green = Color(0xFF315C4B);
  static const _ink = Color(0xFF203029);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 760;
              final board = CrosswordGrid(controller: controller);
              final clues = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) {
                      final isAcross =
                          controller.direction == CrosswordDirection.across;
                      final clue = controller.puzzle.clue(
                        controller.direction,
                        isAcross
                            ? controller.selectedRow
                            : controller.selectedColumn,
                      );
                      final number = isAcross
                          ? controller.selectedRow + 1
                          : controller.selectedColumn + 1;
                      return Semantics(
                        button: true,
                        label: 'Current $clueDirectionText clue, $number: '
                            '${clue.text}. Select to change direction.',
                        child: InkWell(
                          key: const ValueKey('active-clue'),
                          borderRadius: BorderRadius.circular(12),
                          onTap: controller.toggleDirection,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${isAcross ? 'Across' : 'Down'} $number   ${clue.text}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: _ink,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tap a square twice to switch direction',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6F776F),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClueList(
                    controller: controller,
                    direction: CrosswordDirection.across,
                  ),
                  const SizedBox(height: 8),
                  ClueList(
                    controller: controller,
                    direction: CrosswordDirection.down,
                  ),
                ],
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'MINI CROSSWORD',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _green,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.puzzle.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: _ink, fontSize: 16),
                        ),
                        const SizedBox(height: 18),
                        if (wide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: board),
                              const SizedBox(width: 24),
                              Expanded(child: clues),
                            ],
                          )
                        else ...[
                          board,
                          const SizedBox(height: 14),
                          clues,
                        ],
                        const SizedBox(height: 14),
                        const Text(
                          'LETTER KEYS',
                          style: TextStyle(
                            color: _green,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        LetterKeyboard(controller: controller),
                        const SizedBox(height: 8),
                        ListenableBuilder(
                          listenable: controller,
                          builder: (context, _) => Text(
                            controller.message,
                            key: const ValueKey('game-status'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: _ink, fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          children: [
                            FilledButton(
                              key: const ValueKey('check-answers'),
                              onPressed: controller.checkAnswers,
                              child: const Text('Check answers'),
                            ),
                            OutlinedButton(
                              key: const ValueKey('clear-puzzle'),
                              onPressed: controller.clearAnswers,
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

  String get clueDirectionText =>
      controller.direction == CrosswordDirection.across ? 'Across' : 'Down';
}

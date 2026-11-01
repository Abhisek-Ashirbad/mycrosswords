import 'package:flutter/material.dart';

import '../../state/crossword_controller.dart';

class LetterKeyboard extends StatelessWidget {
  const LetterKeyboard({required this.controller, super.key});

  final CrosswordController controller;

  @override
  Widget build(BuildContext context) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 28,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisExtent: 46,
        ),
        itemBuilder: (context, index) {
          if (index == 26) {
            return IconButton.filledTonal(
              key: const ValueKey('letter-erase'),
              tooltip: 'Erase letter',
              onPressed: controller.eraseLetter,
              icon: const Icon(Icons.backspace_outlined),
            );
          }
          if (index == 27) return const SizedBox.shrink();
          final letter = String.fromCharCode(65 + index);
          return Padding(
            padding: const EdgeInsets.all(2),
            child: FilledButton.tonal(
              key: ValueKey('letter-$letter'),
              onPressed: () => controller.enterLetter(letter),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: const Color(0xFF203029),
                backgroundColor: Colors.white,
              ),
              child: Text(letter),
            ),
          );
        },
      );
}

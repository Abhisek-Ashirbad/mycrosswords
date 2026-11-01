import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../state/crossword_controller.dart';

class CrosswordGrid extends StatefulWidget {
  const CrosswordGrid({required this.controller, super.key});

  final CrosswordController controller;

  @override
  State<CrosswordGrid> createState() => _CrosswordGridState();
}

class _CrosswordGridState extends State<CrosswordGrid> {
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(
      widget.controller.puzzle.size * widget.controller.puzzle.size,
      (index) => FocusNode(debugLabel: 'Crossword square $index'),
    );
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth.clamp(0.0, 420.0).toDouble();
        return Center(
          child: SizedBox.square(
            dimension: size,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFD3CFC3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) => GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.puzzle.size * controller.puzzle.size,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: controller.puzzle.size,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      final row = index ~/ controller.puzzle.size;
                      final column = index % controller.puzzle.size;
                      final selected = controller.selectedRow == row &&
                          controller.selectedColumn == column;
                      final letter = controller.letterAt(row, column);
                      return Focus(
                        focusNode: _focusNodes[index],
                        onFocusChange: (focused) {
                          if (focused) controller.selectCell(row, column);
                        },
                        onKeyEvent: (_, event) =>
                            _handleKeyEvent(event, row, column),
                        child: Semantics(
                          button: true,
                          label:
                              'Row ${row + 1}, column ${column + 1}, '
                              '${letter.isEmpty ? 'blank' : letter}',
                          child: GestureDetector(
                            key: ValueKey('cell-$row-$column'),
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              controller.tapCell(row, column);
                              _focusNodes[index].requestFocus();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFFDAEAD4)
                                    : Colors.white,
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF315C4B)
                                      : const Color(0xFFDFDED6),
                                  width: selected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                    top: 3,
                                    left: 5,
                                    child: Text(
                                      '${row + 1}',
                                      style: const TextStyle(
                                        color: Color(0xFF203029),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    letter,
                                    style: const TextStyle(
                                      color: Color(0xFF203029),
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  KeyEventResult _handleKeyEvent(KeyEvent event, int row, int column) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final controller = widget.controller;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowLeft) {
      return controller.moveSelection(0, -1)
          ? _focusSelectedCell()
          : KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      return controller.moveSelection(0, 1)
          ? _focusSelectedCell()
          : KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      return controller.moveSelection(-1, 0)
          ? _focusSelectedCell()
          : KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      return controller.moveSelection(1, 0)
          ? _focusSelectedCell()
          : KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.select) {
      if (controller.selectedRow == row && controller.selectedColumn == column) {
        controller.toggleDirection();
      } else {
        controller.selectCell(row, column);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.backspace ||
        key == LogicalKeyboardKey.delete) {
      controller.eraseLetter();
      return KeyEventResult.handled;
    }
    final character = key.keyLabel.toUpperCase();
    if (character.length == 1 &&
        character.codeUnitAt(0) >= 65 &&
        character.codeUnitAt(0) <= 90) {
      controller.enterLetter(character);
      _focusSelectedCell();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _focusSelectedCell() {
    final index = widget.controller.selectedRow * widget.controller.puzzle.size +
        widget.controller.selectedColumn;
    _focusNodes[index].requestFocus();
    return KeyEventResult.handled;
  }
}

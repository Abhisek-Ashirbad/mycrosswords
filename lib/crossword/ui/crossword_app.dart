import 'package:flutter/material.dart';

import '../state/crossword_controller.dart';
import 'screens/game_screen.dart';

class CrosswordApp extends StatelessWidget {
  const CrosswordApp({required this.controller, super.key});

  final CrosswordController controller;

  static const _green = Color(0xFF315C4B);
  static const _paper = Color(0xFFF5F3EC);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Mini Crossword',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: _green,
            surface: _paper,
          ),
          scaffoldBackgroundColor: _paper,
          visualDensity: VisualDensity.standard,
        ),
        home: GameScreen(controller: controller),
      );
}

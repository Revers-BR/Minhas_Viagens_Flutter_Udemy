import 'package:flutter/material.dart';
import 'package:minhas_viagens_flutter_udemy/telas/splash_screen.dart';

void main() {
  const Color backgroundColor = Color(0xff0066cc);
  const Color foregroundColor = Colors.white;

  runApp(MaterialApp(
    title: "Minhas Viagens",
    home: const SplashScreen(),
    theme: ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor
      )
    ),
  ));
}
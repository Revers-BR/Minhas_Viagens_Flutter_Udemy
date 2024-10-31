import 'package:flutter/material.dart';
import 'package:minhas_viagens_flutter_udemy/telas/splash_screen.dart';

void main() {
  runApp(MaterialApp(
    title: "Minhas Viagens",
    home: const SplashScreen(),
    theme: ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff0066cc),
        foregroundColor: Colors.white
      )
    ),
  ));
}
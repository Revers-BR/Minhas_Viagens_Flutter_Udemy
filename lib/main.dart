import 'package:flutter/material.dart';
import 'package:minhas_viagens_flutter_udemy/telas/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minhas_viagens_flutter_udemy/telas/home.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home())
      );
    });
  }

  @override
  Widget build (BuildContext context ){
    return Scaffold(
      body: Container(
        color: const Color(0xff0066cc),
        padding: const EdgeInsets.all(60),
        child: Center(
          child: Image.asset("assets/imagens/logo.png"),
        ),
      )
    );
  }
}
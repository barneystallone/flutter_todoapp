import 'dart:async';

import 'package:flutter/material.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 1),
      () {
        Route route = MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
        Navigator.push(context, route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Image.asset(
        'assets/images/todo_icon.jpg',
        width: 90.0,
        fit: BoxFit.contain,
      ),
    )));
  }
}

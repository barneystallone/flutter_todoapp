import 'package:flutter/material.dart';
import 'package:todoapp_v1/pages/auth.dart';
import 'package:todoapp_v1/pages/home_page.dart';

import '../services/local/shared_prefs.dart';

class RequiredAuth extends StatefulWidget {
  const RequiredAuth({super.key});

  @override
  State<RequiredAuth> createState() => _RequiredAuthState();
}

class _RequiredAuthState extends State<RequiredAuth> {
  final SharedPrefs _prefs = SharedPrefs();
  Widget checkLogin() {
    bool isLogin = false;
    _prefs.getUsername().then((value) {
      isLogin = (value == null);
    });
    return isLogin ? const HomePage() : const Auth();
  }

  @override
  Widget build(BuildContext context) {
    return checkLogin();
  }
}

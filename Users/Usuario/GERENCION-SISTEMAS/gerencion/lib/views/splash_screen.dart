import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF2B2B2A), Color(0xFF2B2B2A)],
    ),
  ),
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        body: Center(
          child: SvgPicture.asset(
            'assets/images/logo.svg', 
            width: 400, 
            height: 300,
            fit: BoxFit.contain
          ),
        ),
      ),
    );
  }
}
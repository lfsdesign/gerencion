import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Mantemos seus imports
import 'package:get/get.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gerencion Sistemas', 
      theme: ThemeData(
        brightness: Brightness.dark, 

        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      ),
      home: const SplashScreen(),
    ),
  );
}
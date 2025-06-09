import 'package:flutter/material.dart';
import 'splash_screen.dart';
//import 'app_material_page.dart'; // Ensure this points to your currency_converter.dart file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

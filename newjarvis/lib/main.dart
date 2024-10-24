import 'package:flutter/material.dart';
import 'package:newjarvis/pages/home_page.dart';
import 'package:newjarvis/themes/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const SafeArea(child: Scaffold(body: HomePage())),
    );
  }
}

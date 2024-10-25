import 'package:flutter/material.dart';
import 'package:newjarvis/components/route_controller.dart';
import 'package:newjarvis/themes/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Jarvis',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      navigatorKey: RouteController.navigatorKey,
      initialRoute: RouteController.home,
      onGenerateRoute: RouteController.generateRoute,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:newjarvis/components/route_controller.dart';
import 'package:newjarvis/providers/auth_provider.dart';
import 'package:newjarvis/services/auth_state.dart';
import 'package:newjarvis/themes/light_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(context)),
      ],
      child: MaterialApp(
        title: 'New Jarvis',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        onGenerateRoute: RouteController.generateRoute,
        initialRoute: '/auth',
      ),
    );
  }
}

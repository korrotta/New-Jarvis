import 'package:flutter/material.dart';
import 'package:newjarvis/pages/bots_page.dart';
import 'package:newjarvis/pages/chat_page.dart';
import 'package:newjarvis/services/auth_gate.dart';

class RouteController {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String auth = '/auth';
  static const String chat = '/chat';
  static const String bots = '/bots';
  static const String email = '/email';
  static const String search = '/search';
  static const String write = '/write';
  static const String translate = '/translate';
  static const String screenArt = '/screenArt';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthGate());
      case chat:
        return MaterialPageRoute(builder: (_) => const ChatPage());
      case bots:
        return MaterialPageRoute(builder: (_) => const BotsPage());
      default:
        return MaterialPageRoute(builder: (_) => const AuthGate());
    }
  }

  static void navigateTo(int index) {
    switch (index) {
      case 0:
        navigatorKey.currentState!.pushNamed(chat);
        break;
      case 1:
        navigatorKey.currentState!.pushNamed(bots);
        break;

      default:
        navigatorKey.currentState!.pushNamed(auth);
    }
  }

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      auth: (context) => const AuthGate(),
      chat: (context) => const ChatPage(),
      bots: (context) => const BotsPage(),
    };
  }

  static List<Map<String, dynamic>> sideBarItems = [
    {
      'icon': Icons.chat_bubble_rounded,
      'label': 'Chat',
      'route': chat,
    },
    {
      'icon': Icons.smart_toy_rounded,
      'label': 'AI Bots',
      'route': bots,
    },
  ];
}

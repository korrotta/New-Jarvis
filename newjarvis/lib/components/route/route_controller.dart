import 'package:flutter/material.dart';
import 'package:newjarvis/pages/knowledge_base.dart';
import 'package:newjarvis/pages/personal_page.dart';
import 'package:newjarvis/pages/chat_page.dart';
import 'package:newjarvis/services/auth_gate.dart';

class RouteController {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String auth = '/auth';
  static const String chat = '/chat';
  static const String personal = '/personal';
  static const String email = '/email';
  static const String search = '/search';
  static const String write = '/write';
  static const String translate = '/translate';
  static const String screenArt = '/screenArt';
  static const String knowledge = '/knowledge';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthGate());
      case chat:
        return MaterialPageRoute(builder: (_) => const ChatPage());
      case personal:
        return MaterialPageRoute(builder: (_) => const PersonalPage());
      case knowledge:
        return MaterialPageRoute(builder: (_) => const KnowledgePage());
      default:
        return MaterialPageRoute(builder: (_) => const AuthGate());
    }
  }

  static void navigateTo(int index) {
    switch (index) {
      case 0:
        navigatorKey.currentState!.pushReplacementNamed(chat);
        break;
      case 1:
        navigatorKey.currentState!.pushReplacementNamed(personal);
        break;
      case 2:
        navigatorKey.currentState!.pushReplacementNamed(knowledge);
        break;
    }
  }

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      auth: (context) => const AuthGate(),
      chat: (context) => const ChatPage(),
      personal: (context) => const PersonalPage(),
      knowledge: (context) => const KnowledgePage(),
    };
  }

  static List<Map<String, dynamic>> sideBarItems = [
    {
      'icon': Icons.chat_bubble_rounded,
      'label': 'Chat',
      'route': chat,
    },
    {
      'icon': Icons.person_rounded,
      'label': 'Personal',
      'route': personal,
    },
    {
      'icon': Icons.book_rounded,
      'label': 'Knowledge Base',
      'route': knowledge,
    },
  ];
}

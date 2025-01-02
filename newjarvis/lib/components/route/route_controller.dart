import 'package:flutter/material.dart';
import 'package:newjarvis/pages/assistant_page.dart';
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
  static const String assistant = '/assistant';

  static String arguments = '';

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
      case assistant:
        return MaterialPageRoute(
            builder: (_) => AssistantPage(
                  assistantId: arguments,
                ));
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

  static void navigateToPage(String route, {Object? arguments}) {
    if (arguments != null) {
      RouteController.arguments = arguments.toString();
    }
    navigatorKey.currentState!.pushNamed(route, arguments: arguments);
  }

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      auth: (context) => const AuthGate(),
      chat: (context) => const ChatPage(),
      personal: (context) => const PersonalPage(),
      knowledge: (context) => const KnowledgePage(),
    };
  }

  static void pop() {
    navigatorKey.currentState!.pop();
  }
}

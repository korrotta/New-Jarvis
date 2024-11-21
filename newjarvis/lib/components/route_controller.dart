import 'package:flutter/material.dart';
import 'package:newjarvis/pages/chat_page.dart';
import 'package:newjarvis/pages/screen_art.dart';
import 'package:newjarvis/pages/screen_email.dart';
import 'package:newjarvis/pages/screen_write.dart';
import 'package:newjarvis/pages/search/search_page.dart';
import 'package:newjarvis/pages/translate/translate_page.dart';
import 'package:newjarvis/services/auth_gate.dart';

class RouteController {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String auth = '/auth';
  static const String chat = '/chat';
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
      case email:
        return MaterialPageRoute(builder: (_) => const ScreenEmail());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case write:
        return MaterialPageRoute(builder: (_) => const ScreenWrite());
      case translate:
        return MaterialPageRoute(builder: (_) => const TranslatePage());
      case screenArt:
        return MaterialPageRoute(builder: (_) => const ScreenArt());
      default:
        return MaterialPageRoute(builder: (_) => const AuthGate());
    }
  }

  static void navigateTo(int index) {
    switch (index) {
      case 0:
        navigatorKey.currentState?.pushNamed(auth);
        break;
      case 1:
        navigatorKey.currentState?.pushNamed(chat);
        break;
      case 2:
        navigatorKey.currentState?.pushNamed(email);
        break;
      case 3:
        navigatorKey.currentState?.pushNamed(search);
        break;
      case 4:
        navigatorKey.currentState?.pushNamed(write);
        break;
      case 5:
        navigatorKey.currentState?.pushNamed(translate);
        break;
      case 6:
        navigatorKey.currentState?.pushNamed(screenArt);
        break;
      default:
        navigatorKey.currentState?.pushNamed(auth);
        break;
    }
  }

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      auth: (context) => const AuthGate(),
      chat: (context) => const ChatPage(),
      email: (context) => const ScreenEmail(),
      search: (context) => const SearchPage(),
      write: (context) => const ScreenWrite(),
      translate: (context) => const TranslatePage(),
      screenArt: (context) => const ScreenArt(),
    };
  }

  static List<Map<String, dynamic>> sideBarItems = [
    {
      'icon': Icons.chat_bubble_rounded,
      'label': 'Chat',
      'route': chat,
    },
    {
      'icon': Icons.email_outlined,
      'label': 'Email',
      'route': email,
    },
    {
      'icon': Icons.search_outlined,
      'label': 'Search',
      'route': search,
    },
    {
      'icon': Icons.edit_outlined,
      'label': 'Write',
      'route': write,
    },
    {
      'icon': Icons.translate_outlined,
      'label': 'Translate',
      'route': translate,
    },
    {
      'icon': Icons.brush_outlined,
      'label': 'Art',
      'route': screenArt,
    },
  ];
}

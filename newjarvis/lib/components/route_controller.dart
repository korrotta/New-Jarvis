import 'package:flutter/material.dart';
import 'package:newjarvis/pages/chat_page.dart';
import 'package:newjarvis/pages/device_page.dart';
import 'package:newjarvis/pages/help_page.dart';
import 'package:newjarvis/pages/home_page.dart';
import 'package:newjarvis/pages/login_page.dart';
import 'package:newjarvis/pages/memo_page.dart';
import 'package:newjarvis/pages/read_page.dart';
import 'package:newjarvis/pages/register_page.dart';
import 'package:newjarvis/pages/screen_art.dart';
import 'package:newjarvis/pages/search/search_page.dart';
import 'package:newjarvis/pages/settings_page.dart';
import 'package:newjarvis/pages/toolkit_page.dart';
import 'package:newjarvis/pages/translate_page.dart';
import 'package:newjarvis/pages/write_page.dart';
import 'package:newjarvis/pages/voucher_page.dart';
import 'package:newjarvis/services/auth_gate.dart';

class RouteController {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String home = '/';
  static const String auth = '/auth';
  static const String chat = '/chat';
  static const String read = '/read';
  static const String search = '/search';
  static const String write = '/write';
  static const String translate = '/translate';
  static const String screenArt = '/screenArt';
  static const String toolkit = '/toolkit';
  static const String memo = '/memo';
  static const String devices = '/devices';
  static const String help = '/help';
  static const String setting = '/setting';
  static const String voucher = '/voucher';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthGate());
      case chat:
        return MaterialPageRoute(builder: (_) => const ChatPage());
      case read:
        return MaterialPageRoute(builder: (_) => const ReadPage());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case write:
        return MaterialPageRoute(builder: (_) => const WritePage());
      case translate:
        return MaterialPageRoute(builder: (_) => const TranslatePage());
      case screenArt:
        return MaterialPageRoute(builder: (_) => const ScreenArt());
      case toolkit:
        return MaterialPageRoute(builder: (_) => const ToolkitPage());
      case memo:
        return MaterialPageRoute(builder: (_) => const MemoPage());
      case devices:
        return MaterialPageRoute(builder: (_) => const DevicePage());
      case help:
        return MaterialPageRoute(builder: (_) => const HelpPage());
      case setting:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case voucher:
        return MaterialPageRoute(builder: (_) => const VoucherPage());
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
        navigatorKey.currentState?.pushNamed(read);
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
      case 7:
        navigatorKey.currentState?.pushNamed(toolkit);
        break;
      case 8:
        navigatorKey.currentState?.pushNamed(memo);
        break;
      case 9:
        navigatorKey.currentState?.pushNamed(devices);
        break;
      case 10:
        navigatorKey.currentState?.pushNamed(help);
        break;
      case 11:
        navigatorKey.currentState?.pushNamed(setting);
        break;
      case 12:
        navigatorKey.currentState?.pushNamed(voucher);
        break;
      default:
        navigatorKey.currentState?.pushNamed(auth);
        break;
    }
  }

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomePage(),
      auth: (context) => const AuthGate(),
      chat: (context) => const ChatPage(),
      read: (context) => const ReadPage(),
      search: (context) => const SearchPage(),
      write: (context) => const WritePage(),
      translate: (context) => const TranslatePage(),
      screenArt: (context) => const ScreenArt(),
      toolkit: (context) => const ToolkitPage(),
      memo: (context) => const MemoPage(),
      devices: (context) => const DevicePage(),
      help: (context) => const HelpPage(),
      setting: (context) => const SettingsPage(),
      voucher: (context) => const VoucherPage(),
    };
  }

  static List<Map<String, dynamic>> sideBarItems = [
    {
      'icon': Icons.chat_bubble_rounded,
      'label': 'Chat',
      'route': chat,
    },
    {
      'icon': Icons.menu_book_outlined,
      'label': 'Read',
      'route': read,
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
    {
      'icon': Icons.home_repair_service_outlined,
      'label': 'Toolkit',
      'route': toolkit,
    },
    {
      'icon': Icons.bookmark_add_outlined,
      'label': 'Memo',
      'route': memo,
    },
    {
      'icon': Icons.devices_outlined,
      'label': 'Devices',
      'route': devices,
    },
    {
      'icon': Icons.help_outline,
      'label': 'Question - Ask',
      'route': help,
    },
    {
      'icon': Icons.settings_outlined,
      'label': 'Settings',
      'route': setting,
    },
    {
      'icon': Icons.card_giftcard_outlined,
      'label': 'Voucher - Gift',
      'route': voucher,
    },
  ];
}

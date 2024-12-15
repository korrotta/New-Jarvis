import 'package:flutter/material.dart';
import 'package:newjarvis/components/floating_button.dart';
import 'package:newjarvis/components/side_bar.dart';
import 'package:newjarvis/pages/chat_page.dart';
import 'package:newjarvis/pages/screen_art.dart';
import 'package:newjarvis/pages/screen_email.dart';
import 'package:newjarvis/pages/search/search_page.dart';
import 'package:newjarvis/pages/translate/translate_page.dart';
import 'package:newjarvis/pages/screen_write.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool isExpanded = false;
  bool isSidebarVisible = false;
  double dragOffset = 200.0;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  // Hàm để render nội dung dựa trên selectedIndex
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      isSidebarVisible = false;
    });

    switch (index) {
      case 0:
        _navigatorKey.currentState?.pushReplacementNamed('/chat');
        break;
      case 1:
        _navigatorKey.currentState?.pushReplacementNamed('/email');
        break;
      case 2:
        _navigatorKey.currentState?.pushReplacementNamed('/search');
        break;
      case 3:
        _navigatorKey.currentState?.pushReplacementNamed('/write');
        break;
      case 4:
        _navigatorKey.currentState?.pushReplacementNamed('/translate');
        break;
      case 5:
        _navigatorKey.currentState?.pushReplacementNamed('/art');
        break;
      default:
        _navigatorKey.currentState?.pushReplacementNamed('/home');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Main Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(
              right: isSidebarVisible ? (isExpanded ? 180 : 98) : 0,
            ),
            width: double.infinity,
            child: Navigator(
              key: _navigatorKey,
              initialRoute: '/chat',
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                switch (settings.name) {
                  case '/chat':
                    builder = (BuildContext _) => const ChatPage();
                    break;
                  case '/email':
                    builder = (BuildContext _) => const ScreenEmail();
                    break;
                  case '/search':
                    builder = (BuildContext _) => const SearchPage();
                    break;
                  case '/write':
                    builder = (BuildContext _) => const ScreenWrite();
                    break;
                  case '/translate':
                    builder = (BuildContext _) => const TranslatePage();
                    break;
                  case '/art':
                    builder = (BuildContext _) => const ScreenArt();
                    break;
                  default:
                    builder = (BuildContext _) => const ChatPage();
                    break;
                }
                return MaterialPageRoute(builder: builder, settings: settings);
              },
            ),
          ),

          if (isSidebarVisible)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: SideBar(
                isExpanded: isExpanded,
                selectedIndex: selectedIndex,
                onItemSelected: _onItemTapped,
                onExpandToggle: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                onClose: () {
                  setState(() {
                    isSidebarVisible = false;
                  });
                },
              ),
            ),

          // Nửa hình tròn khi sidebar bị ẩn (Floating Button)
          if (!isSidebarVisible)
            FloatingButton(
              dragOffset: dragOffset,
              onDragUpdate: (delta) {
                setState(
                  () {
                    dragOffset += delta;
                    if (dragOffset < 0) dragOffset = 0;
                    if (dragOffset > MediaQuery.of(context).size.height - 100) {
                      dragOffset = MediaQuery.of(context).size.height - 100;
                    }
                  },
                );
              },
              onTap: () {
                setState(
                  () {
                    isSidebarVisible = true;
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

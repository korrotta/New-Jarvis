import 'package:flutter/material.dart';
import 'package:newjarvis/components/floating_button.dart';
import 'package:newjarvis/components/route_controller.dart';
import 'package:newjarvis/components/side_bar.dart';
import 'package:newjarvis/pages/chat_page.dart';
import 'package:newjarvis/pages/device_page.dart';
import 'package:newjarvis/pages/help_page.dart';
import 'package:newjarvis/pages/memo_page.dart';
import 'package:newjarvis/pages/screen_art.dart';
import 'package:newjarvis/pages/search_page.dart';
import 'package:newjarvis/pages/settings_page.dart';
import 'package:newjarvis/pages/toolkit_page.dart';
import 'package:newjarvis/pages/translate_page.dart';
import 'package:newjarvis/pages/voucher_page.dart';
import 'package:newjarvis/pages/write_page.dart';

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

  // Hàm để render nội dung dựa trên selectedIndex
  Widget _getScreenContent() {
    switch (selectedIndex) {
      case 0:
        return const ChatPage(); // Chat Page
      case 1:
        return const ChatPage(); // Read Page
      case 2:
        return const SearchPage(); // Search Page
      case 3:
        return const WritePage(); // Write Page
      case 4:
        return const TranslatePage(); // Translate Page
      case 5:
        return const ScreenArt(); // Art Page
      case 6:
        return const ToolkitPage(); // Toolkit Page
      case 7:
        return const MemoPage(); // Memo Page
      case 8:
        return const DevicePage(); // Devices Page
      case 9:
        return const HelpPage(); // Question Page
      case 10:
        return const SettingsPage(); // Settings Page
      case 11:
        return const VoucherPage(); // Voucher Page
      default:
        return const HomePage(); // Home Page
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
            child: Scaffold(
              body: _getScreenContent(),
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
                onItemSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                    isSidebarVisible = false;
                  });
                },
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

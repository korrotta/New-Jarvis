import 'package:flutter/material.dart';
import 'package:newjarvis/components/floating_button.dart';
import 'package:newjarvis/components/side_bar.dart';
import 'package:newjarvis/pages/chat_page.dart';
import 'package:newjarvis/pages/screen_art.dart';
import 'package:newjarvis/pages/search/search_page.dart';

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
        return const Center(child: Text("Read Page")); // Read Page
      case 2:
        return const SearchPage(); // Search Page
      case 3:
        return const Center(child: Text("Write Page")); // Write Page
      case 4:
        return const Center(child: Text("Translate Page")); // Translate Page
      case 5:
        return const ScreenArt(); // Art Page
      case 6:
        return const Center(child: Text("Toolkit Page")); // Toolkit Page
      case 7:
        return const Center(child: Text("Memo Page")); // Memo Page
      case 8:
        return const Center(child: Text("Devices Page")); // Devices Page
      case 9:
        return const Center(child: Text("Question Page")); // Question Page
      case 10:
        return const Center(child: Text("Settings Page")); // Settings Page
      case 11:
        return const Center(child: Text("Voucher Page")); // Voucher Page
      default:
        return const HomePage(); // Home Page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(
            right: isSidebarVisible ? (isExpanded ? 180 : 98) : 0,
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              elevation: 0,
            ),
            body: _getScreenContent(), // Nội dung thay đổi ở đây
          ),
        ),

        // Sidebar
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
                setState(
                  () {
                    isSidebarVisible = false;
                  },
                );
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
    );
  }
}

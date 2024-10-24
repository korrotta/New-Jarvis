import 'package:flutter/material.dart';
import 'package:newjarvis/pages/chat_page.dart';
import 'package:newjarvis/themes/light_theme.dart';

import 'package:newjarvis/pages/screen_art.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const SafeArea(child: Scaffold(body: HomePage())),
    );
  }
}

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

  List<IconData> menuIcons = [
    Icons.chat_bubble_rounded,
    Icons.menu_book_outlined,
    Icons.search_outlined,
    Icons.edit_outlined,
    Icons.translate_outlined,
    Icons.brush_outlined,
    Icons.home_repair_service_outlined,
    Icons.bookmark_add_outlined,
    Icons.devices_outlined,
    Icons.help_outline,
    Icons.settings_outlined,
    Icons.card_giftcard_outlined,
  ];

  List<String> menuLabels = [
    'Chat',
    'Read',
    'Search',
    'Write',
    'Translate',
    'Art',
    'Toolkit',
    'Memo',
    'Devices',
    'Question - Ask',
    'Settings',
    'Voucher - Gift',
  ];

  // Hàm để render nội dung dựa trên selectedIndex
  Widget _getScreenContent() {
    switch (selectedIndex) {
      case 0:
        return const ChatPage(); // Trang Chat
      case 1:
        return const Center(child: Text("Read Page"));
      case 2:
        return const Center(child: Text("Search Page"));
      case 3:
        return const Center(child: Text("Write Page"));
      case 4:
        return const Center(child: Text("Translate Page"));
      case 5:
        return const ScreenArt(); // Trang Art
      case 6:
        return const Center(child: Text("Toolkit Page"));
      case 7:
        return const Center(child: Text("Memo Page"));
      case 8:
        return const Center(child: Text("Devices Page"));
      case 9:
        return const Center(child: Text("Question Page"));
      case 10:
        return const Center(child: Text("Settings Page"));
      case 11:
        return const Center(child: Text("Voucher Page"));
      default:
        return const Center(child: Text("Default Page"));
    }
  }

  @override
  Widget build(BuildContext context) {
    double sidebarWidth = isExpanded ? 180 : 98;

    return Stack(
      children: [
        // Nội dung chính của trang, được cập nhật theo selectedIndex
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(right: isSidebarVisible ? sidebarWidth : 0),
          child: Scaffold(
            //appBar: AppBar(
              //title: const Text("Welcome to Jarvis - Chat Bot AI Knowledged"),
            //),
            body: _getScreenContent(), // Nội dung thay đổi ở đây
          ),
        ),

        // Sidebar
        if (isSidebarVisible)
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Container(
              width: sidebarWidth,
              color: const Color.fromARGB(207, 238, 235, 235),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isExpanded ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.grey[600], size: 21),
                          onPressed: () {
                            setState(() {
                              isSidebarVisible = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: isExpanded ? buildExpandedMenu() : buildCollapsedMenu(),
                  ),
                ],
              ),
            ),
          ),

        // Nửa hình tròn khi sidebar bị ẩn
        if (!isSidebarVisible)
          Positioned(
            right: 0,
            top: dragOffset,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  dragOffset += details.delta.dy;
                  if (dragOffset < 0) dragOffset = 0;
                  if (dragOffset > MediaQuery.of(context).size.height - 100) {
                    dragOffset = MediaQuery.of(context).size.height - 100;
                  }
                });
              },
              onTap: () {
                setState(() {
                  isSidebarVisible = true;
                });
              },
              child: Container(
                width: 55,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(240, 213, 238, 248),
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(40)),
                ),
                child: Center(
                  child: Image.asset("assets/icons/icon.png", width: 25, height: 25),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildExpandedMenu() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: menuIcons.length,
            itemBuilder: (context, index) {
              bool isSelected = selectedIndex == index;
              return Column(
                children: [
                  if (index == 7)
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                    ),
                  if (index == 8) const SizedBox(height: 70.0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 2.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          bottomLeft: Radius.circular(0),
                          topRight: Radius.circular(300),
                          bottomRight: Radius.circular(300),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              menuIcons[index],
                              color: isSelected ? const Color.fromARGB(255, 0, 4, 131) : Colors.grey[600],
                              size: 28,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Text(
                              menuLabels[index],
                              style: TextStyle(
                                color: isSelected ? const Color.fromARGB(255, 0, 4, 131) : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 20),
          Align(
            child: ClipOval(
              child: Image.asset(
                "assets/icons/icon.png",
                width: 26,
                height: 26,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ]
        ),
      ],
    );
  }

  Widget buildCollapsedMenu() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: menuIcons.length,
            itemBuilder: (context, index) {
              bool isSelected = selectedIndex == index;
              return Column(
                children: [
                  if (index == 7)
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                    ),
                  if (index == 8) const SizedBox(height: 70.0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          bottomLeft: Radius.circular(0),
                          topRight: Radius.circular(360),
                          bottomRight: Radius.circular(360),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            menuIcons[index],
                            color: isSelected ? const Color.fromARGB(255, 0, 4, 131) : Colors.grey[600],
                            size: 26,
                          ),
                          const SizedBox(height: 3.5),
                          if (index < 8)
                            Text(
                              menuLabels[index],
                              style: TextStyle(
                                color: isSelected ? const Color.fromARGB(255, 0, 4, 131) : Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Align(
            alignment: Alignment.center,
            child: ClipOval(
              child: Image.asset(
                "assets/icons/icon.png",
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


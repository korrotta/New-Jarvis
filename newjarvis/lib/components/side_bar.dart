import 'package:flutter/material.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:newjarvis/services/auth_gate.dart';

class SideBar extends StatelessWidget {
  final bool isExpanded;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final Function onExpandToggle;
  final Function onClose;

  const SideBar({
    super.key,
    required this.isExpanded,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onExpandToggle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    double sidebarWidth = isExpanded ? 180 : 98;

    return Container(
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
                  onPressed: () => onExpandToggle(),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[600], size: 21),
                  onPressed: () => onClose(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: isExpanded ? _buildExpandedMenu() : _buildCollapsedMenu(),
          ),

          // Sign out button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              backgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              // Handle signout here
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AuthGate();
                  },
                ),
              );
              ApiService().signOut();
            },
            child: Text(
              'Sign out',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedMenu() {
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
                  if (index == 8) const SizedBox(height: 90.0),
                  GestureDetector(
                    onTap: () => onItemSelected(index),
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
                              color: isSelected
                                  ? const Color.fromARGB(255, 0, 4, 131)
                                  : Colors.grey[600],
                              size: 28,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Text(
                              menuLabels[index],
                              style: TextStyle(
                                color: isSelected
                                    ? const Color.fromARGB(255, 0, 4, 131)
                                    : Colors.grey[600],
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ClipOval(
                child: Image.asset(
                  "assets/icons/icon.png",
                  width: 26,
                  height: 26,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCollapsedMenu() {
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
                    onTap: () => onItemSelected(index),
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
                            color: isSelected
                                ? const Color.fromARGB(255, 0, 4, 131)
                                : Colors.grey[600],
                            size: 26,
                          ),
                          const SizedBox(height: 3.5),
                          if (index < 8)
                            Text(
                              menuLabels[index],
                              style: TextStyle(
                                color: isSelected
                                    ? const Color.fromARGB(255, 0, 4, 131)
                                    : Colors.grey[600],
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

const List<IconData> menuIcons = [
  Icons.chat_bubble_rounded,
  Icons.email_outlined,
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

const List<String> menuLabels = [
  'Chat',
  'Email',
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

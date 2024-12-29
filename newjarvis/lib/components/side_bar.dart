import 'package:flutter/material.dart';
import 'package:newjarvis/providers/auth_provider.dart';
import 'package:provider/provider.dart';

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
    double sidebarWidth = isExpanded ? 220 : 80;

    return Container(
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: const Color(0xFF608BC1), // Light blue background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => onExpandToggle(),
                ),
                if (isExpanded)
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                    onPressed: () => onClose(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isExpanded
                ? _buildExpandedMenu(context)
                : _buildCollapsedMenu(context),
          ),
          const SizedBox(height: 10),
          _buildSignOutButton(context),
        ],
      ),
    );
  }

  Widget _buildExpandedMenu(BuildContext context) {
    return ListView.builder(
      itemCount: menuIcons.length,
      itemBuilder: (context, index) {
        bool isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () => onItemSelected(index),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue[200] // Highlight for selected menu
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    menuIcons[index],
                    color: isSelected ? Colors.blue[800] : Colors.white,
                    size: 24,
                  ),
                ),
                if (isExpanded)
                  Text(
                    menuLabels[index],
                    style: TextStyle(
                      color: isSelected ? Colors.blue[800] : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCollapsedMenu(BuildContext context) {
    return ListView.builder(
      itemCount: menuIcons.length,
      itemBuilder: (context, index) {
        bool isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () => onItemSelected(index),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue[200] // Highlight for selected menu
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                menuIcons[index],
                color: isSelected ? Colors.blue[800] : Colors.white,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Provider.of<AuthProvider>(context, listen: false).signOut(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.redAccent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              color: Colors.white,
              size: 20,
            ),
            if (isExpanded) const SizedBox(width: 10),
            if (isExpanded)
              const Text(
                'Sign out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

const List<IconData> menuIcons = [
  Icons.chat_bubble_rounded,
  Icons.person_rounded,
  Icons.book_rounded,
  Icons.settings_outlined,
  
];

const List<String> menuLabels = [
  'Chat',
  'Personal',
  'Knowledge Base',
  'Settings',
];

import 'package:flutter/cupertino.dart';
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
    const double sideBarWidthExpanded = 200; // Dung thay doi cai nay nha
    const double sideBarWidthCollapsed = 85; // Dung thay doi cai nay nha
    double sidebarWidth =
        isExpanded ? sideBarWidthExpanded : sideBarWidthCollapsed;

    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.inversePrimary,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: isExpanded
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: Container(
                    margin: isExpanded
                        ? const EdgeInsets.only(left: 10)
                        : const EdgeInsets.all(0),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const CustomForwardIcon(),
                  ),
                  onTap: () => onClose(),
                ),
                GestureDetector(
                  child: Container(
                    margin: isExpanded
                        ? const EdgeInsets.only(right: 10)
                        : const EdgeInsets.all(0),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const CustomExpandIcon(),
                  ),
                  onTap: () => onExpandToggle(),
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
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              border: Border(
                left: isSelected
                    ? const BorderSide(color: Colors.blueAccent, width: 3.5)
                    : const BorderSide(color: Colors.transparent, width: 3.5),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    menuIcons[index],
                    color: isSelected
                        ? Colors.blueAccent
                        : Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
                if (isExpanded)
                  Text(
                    menuLabels[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.blueAccent
                          : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
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
              border: Border(
                left: isSelected
                    ? const BorderSide(color: Colors.blueAccent, width: 3.0)
                    : const BorderSide(color: Colors.transparent, width: 3.0),
                right: const BorderSide(color: Colors.transparent, width: 3.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Icon(
                    menuIcons[index],
                    color: isSelected
                        ? Colors.blueAccent
                        : Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  Text(
                    menuLabels[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.blueAccent
                          : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    softWrap: false, // Không wrap chữ
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                  ),
                ],
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
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              color: Colors.redAccent,
              size: 28,
            ),
            if (isExpanded) const SizedBox(width: 10),
            if (isExpanded)
              const Text(
                'Sign out',
                style: TextStyle(
                  color: Colors.redAccent,
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
  CupertinoIcons.chat_bubble_text_fill,
  CupertinoIcons.bolt_horizontal_circle_fill,
  CupertinoIcons.book_circle_fill,
  CupertinoIcons.envelope_fill,
  Icons.settings_outlined,
];

const List<String> menuLabels = [
  'Chat',
  'AI Assistant',
  'Knowledge Base',
  'Email',
  'Settings',
];

class CustomForwardIcon extends StatelessWidget {
  const CustomForwardIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Forward arrow
        const Icon(
          CupertinoIcons.chevron_right,
          size: 14,
          color: Colors.black,
        ),
        // Vertical line
        Positioned(
          right: 0,
          child: Transform.scale(
            scaleY: 1.5,
            child: Transform.rotate(
              angle: 1.57,
              child: const Icon(
                Icons.horizontal_rule,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomExpandIcon extends StatelessWidget {
  const CustomExpandIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Forward arrow
        Transform.rotate(
          angle: 1.57,
          child: const Icon(
            Icons.unfold_more_outlined,
            size: 18,
            color: Colors.black,
          ),
        ),
        // Vertical line
        Transform.scale(
          scaleY: 1.2,
          child: Transform.rotate(
            angle: 1.57,
            child: const Icon(
              Icons.horizontal_rule,
              size: 14,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class EndDrawerSection extends StatelessWidget {
  const EndDrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      width: MediaQuery.of(context).size.width * 0.3,
      child: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row for Minimize and Close buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  icon: Icon(Icons.remove,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () {},
                ),
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  icon: Icon(Icons.close_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),

            // Drawer Content
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  // Chat ListTile
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Icon(Icons.chat_bubble_outline,
                        color: Theme.of(context).colorScheme.primary),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    subtitle: Text(
                      'Chat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),

                  // Read ListTile
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Icon(Icons.menu_book_outlined,
                        color: Theme.of(context).colorScheme.primary),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    subtitle: Text(
                      'Read',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),

                  // Search ListTile
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Icon(Icons.search_outlined,
                        color: Theme.of(context).colorScheme.primary),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    subtitle: Text(
                      'Search',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),

                  // Write ListTile
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Icon(Icons.edit_outlined,
                        color: Theme.of(context).colorScheme.primary),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    subtitle: Text(
                      'Write',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),

                  // Translate ListTile
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Icon(Icons.g_translate_outlined,
                        color: Theme.of(context).colorScheme.primary),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    subtitle: Text(
                      'Translate',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),

                  // Art ListTile
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Icon(Icons.brush_outlined,
                        color: Theme.of(context).colorScheme.primary),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    subtitle: Text(
                      'Art',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),

                  // Toolkit ListTile
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Icon(Icons.home_repair_service_outlined,
                        color: Theme.of(context).colorScheme.primary),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    subtitle: Text(
                      'Toolkit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),

                  // Horizontal Divider
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),

                  // Memo ListTile
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    subtitle: Text('Memo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary)),
                    title: Icon(
                      Icons.bookmark_add_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  // SizedBox
                  const SizedBox(height: 30),

                  // Devices
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Icon(Icons.devices_outlined,
                        color: Theme.of(context).colorScheme.primary),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  // Help
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Icon(Icons.help_outline,
                        color: Theme.of(context).colorScheme.primary),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  // Settings
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Icon(Icons.settings_outlined,
                        color: Theme.of(context).colorScheme.primary),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  // Giftbox
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Icon(Icons.card_giftcard_outlined,
                        color: Theme.of(context).colorScheme.primary),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        titleTextStyle: TextStyle(
          color: Theme.of(context).appBarTheme.foregroundColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      endDrawer: Container(
        margin: const EdgeInsets.only(top: 50),
        width: MediaQuery.of(context).size.width * 0.24,
        child: Drawer(
          child: ListView(
            children: [
              // Chat ListTile
              ListTile(
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
                padding: EdgeInsets.only(left: 12.0, right: 12.0),
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),

              // Memo ListTile
              ListTile(
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

              // Devices
              ListTile(
                title: Icon(Icons.devices_outlined,
                    color: Theme.of(context).colorScheme.primary),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              // Help
              ListTile(
                title: Icon(Icons.help_outline,
                    color: Theme.of(context).colorScheme.primary),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              // Settings
              ListTile(
                title: Icon(Icons.settings_outlined,
                    color: Theme.of(context).colorScheme.primary),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              // Giftbox
              ListTile(
                title: Icon(Icons.card_giftcard_outlined,
                    color: Theme.of(context).colorScheme.primary),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ExpansionTile(
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  title: const Text(
                    'Personalize your Monica',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Monica will automatically use enabled skills\n'
                        'Advanced skills are only available when GPT-4 is enabled.\n',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                        ),
                      ),
                    ),

                    // Basic Skills
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Basic Skills',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    // Web Access ListTile
                    ListTile(
                      leading: const Icon(Icons.language_outlined),
                      title: const Text(
                        'Web Access',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      trailing: CupertinoSwitch(
                        value: false,
                        onChanged: (value) {
                          setState(() {
                            value = !value;
                          });
                        },
                      ),
                    ),

                    // Advanced Skills
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Advanced Skills',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 11,
                        ),
                      ),
                    ),

                    // Create Image (DALL·E 3) ListTile
                    ListTile(
                      leading: const Icon(
                        Icons.brush_outlined,
                      ),
                      title: const Text('Create Image (DALL·E 3)',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      trailing: CupertinoSwitch(
                        value: false,
                        onChanged: (value) {
                          setState(() {
                            value = !value;
                          });
                        },
                      ),
                    ),

                    // Book Calendar Events ListTile
                    ListTile(
                      leading: const Icon(Icons.calendar_month_outlined),
                      title: const Text('Book Calendar Events',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      trailing: CupertinoSwitch(
                        value: false,
                        onChanged: (value) {
                          setState(() {
                            value = !value;
                          });
                        },
                      ),
                    ),

                    // Learn from your chats ListTile
                    ListTile(
                      leading: const Icon(Icons.compost_outlined),
                      title: const Text('Learn from your chats',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      trailing: CupertinoSwitch(
                        value: false,
                        onChanged: (value) {
                          setState(() {
                            value = !value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // AI Search Section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.search,
                        color: Theme.of(context).primaryColor),
                    title: const Text('AI Search'),
                    subtitle: const Text('Smarter and save your time'),
                    onTap: () {
                      // Action for AI Search
                    },
                  ),
                ),
              ),

              // Writing Agent Section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading:
                        Icon(Icons.edit, color: Theme.of(context).primaryColor),
                    title: const Text('Writing Agent'),
                    subtitle: const Text('Auto Agent'),
                    onTap: () {
                      // Action for Writing Agent
                    },
                  ),
                ),
              ),

              // Other UI components (like Upload)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.upload_file,
                        color: Theme.of(context).primaryColor),
                    title: const Text('Upload'),
                    subtitle: const Text('Click/drag and drop here to chat'),
                    onTap: () {
                      // Action for Upload
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

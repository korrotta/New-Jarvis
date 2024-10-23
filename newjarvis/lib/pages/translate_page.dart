import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({Key? key}) : super(key: key);

  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  bool gpt4Enabled = false;
  String sourceText = '';
  String translatedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Translate'),
        elevation: 0,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.history),
        //     onPressed: () {
        //       // Handle history action
        //     },
        //   ),
        // ],
      ),
      endDrawer: endDrawerSection(context), // Using your original end drawer
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSearchBar(),
            const SizedBox(height: 15),
            const Text(
              'Discover',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildTranslationCards(),
            const SizedBox(height: 20),
            buildTranslationInput(),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 200, // Height set to 200 as requested
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), // Rounded corners
        border: Border.all(
          color: Colors.purple.shade300, // Purple border for design match
          width: 1.5,
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Spacing between rows
        children: [
          // First Row: Search Icon and Text Field
          Row(
            children: [
              const Icon(
                Icons.search_outlined,
                color: Colors.grey,
                size: 30,
              ),
              const SizedBox(width: 15), // Space between icon and input field
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'What do you want to translate?',
                    border: InputBorder.none,
                    isDense: true, // Compact layout
                  ),
                  style: const TextStyle(
                      fontSize: 20), // Larger font for better proportions
                ),
              ),
            ],
          ),
          // Second Row: GPT-4 Switch and Label
          Row(
            mainAxisAlignment:
                MainAxisAlignment.end, // Align items to the right
            children: [
              Transform.scale(
                scale: 1.2, // Adjust switch size for better fit
                child: CupertinoSwitch(
                  value: gpt4Enabled,
                  onChanged: (value) {
                    setState(() {
                      gpt4Enabled = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8), // Space between switch and text
              const Text(
                'GPT-4',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18, // Larger font for better visibility
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTranslationCards() {
    return Expanded(
      child: ListView(
        children: [
          buildListTile(
            icon: Icons.language,
            title: 'Translate languages',
            subtitle: 'Instant language translation support',
          ),
          buildListTile(
            icon: Icons.text_fields,
            title: 'Text Translation',
            subtitle: 'Translate paragraphs or documents',
          ),
          buildListTile(
            icon: Icons.mic,
            title: 'Speech Translation',
            subtitle: 'Real-time speech-to-text translation',
          ),
        ],
      ),
    );
  }

  Widget buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {},
    );
  }

  Widget buildTranslationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter text to translate:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          maxLines: 3,
          onChanged: (text) {
            setState(() {
              sourceText = text;
            });
          },
          decoration: InputDecoration(
            hintText: 'Type here...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Perform translation logic
            setState(() {
              translatedText = "Translation of: $sourceText";
            });
          },
          child: const Text('Translate'),
        ),
        const SizedBox(height: 10),
        Text(
          translatedText,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Container endDrawerSection(BuildContext context) {
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

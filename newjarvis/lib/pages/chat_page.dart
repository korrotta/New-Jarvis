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
      // Empty AppBar
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      endDrawer: endDrawerSection(context),

      // Monica Chat Section
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Column(
          children: [
            // Personalize Monica Section
            personalizeSection(context),

            // AI Search Section
            aiSearchSection(context),

            // Upload Section
            uploadSection(context),

            // Writing Agent Section
            writingAgentSection(context),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: bottomNavSection(context),
    );
  }

  Container bottomNavSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // AI Model Selection
          modelSection(context),
          // Chat Input Section
          chatInputSection(context),
          // Switches
          bottomSwitchSection(context),
        ],
      ),
    );
  }

  Padding personalizeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.transparent,
            width: 1,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            title: const Text(
              'Personalize your Monica',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 13,
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
                    fontWeight: FontWeight.w500,
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
                    fontWeight: FontWeight.w500,
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
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
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
                    fontWeight: FontWeight.w500,
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
      ),
    );
  }

  Padding aiSearchSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.search_outlined,
              color: Theme.of(context).colorScheme.inversePrimary,
              size: 50,
            ),
          ),
          title: const Text(
            'AI Search',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: const Text(
            'Smarter and save your time',
          ),
          onTap: () {},
        ),
      ),
    );
  }

  Padding uploadSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(Icons.upload_file_outlined,
              color: Theme.of(context).primaryColor),
          title: const Text('Upload'),
          onTap: () {},
        ),
      ),
    );
  }

  Padding writingAgentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // Background image
            Image.asset(
              'assets/icons/icon.png',
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            // Text
            Text(
              'Writing Agent',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView bottomSwitchSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Web Access Switch
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.auto_awesome_outlined,
                      size: 14,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  Text(
                    'Web Access',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.6,
                    child: CupertinoSwitch(
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
              // GPT-4 Switch
              Row(
                children: [
                  Text(
                    'GPT-4',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.6,
                    child: CupertinoSwitch(
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
            ],
          ),

          // Chat with Memo Switch
          Row(
            children: [
              Text(
                'Chat with Memo',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Transform.scale(
                scale: 0.6,
                child: CupertinoSwitch(
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
        ],
      ),
    );
  }

  Padding chatInputSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Ask me anything, press \'/\' for prompts',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                      // Transparent border
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.plus_slash_minus,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Icon(
                                CupertinoIcons.minus_slash_plus,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.alternate_email_outlined,
                                color: Theme.of(context).colorScheme.primary),
                            onPressed: () {
                              // Handle @ action
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.mic_none_outlined,
                                color: Theme.of(context).colorScheme.primary),
                            onPressed: () {
                              // Handle mic action
                            },
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.send_sharp,
                            color: Theme.of(context).colorScheme.primary),
                        onPressed: () {
                          // Handle send action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IntrinsicHeight modelSection(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DropdownButton<String>(
            items: <String>['Monica', 'Gemini', 'Genius'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {},
            hint: const Text(
              'Select AI Model',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Icons
          Icon(
            Icons.import_contacts_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          Icon(
            Icons.add_photo_alternate_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          Icon(
            Icons.description_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          Icon(
            Icons.cut_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: VerticalDivider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 1,
              width: 1,
            ),
          ),
          Icon(
            Icons.tune_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          Icon(
            Icons.history_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.14),
              child: Icon(
                Icons.add_comment_outlined,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container personalizeMonicaSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.transparent,
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: const Text(
            'Personalize your Monica',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 13,
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
                  fontWeight: FontWeight.w500,
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
                  fontWeight: FontWeight.w500,
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
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
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
                  fontWeight: FontWeight.w500,
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

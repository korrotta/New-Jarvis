import 'package:flutter/material.dart';
import 'package:newjarvis/components/ai_chat/ai_model_selection_section.dart';
import 'package:newjarvis/components/language_component.dart';
import 'package:newjarvis/enums/id.dart';
import 'package:newjarvis/models/assistant_model.dart';
import 'package:provider/provider.dart';
import 'package:newjarvis/components/route/route_controller.dart';
import 'package:newjarvis/components/widgets/floating_button.dart';
import 'package:newjarvis/components/widgets/side_bar.dart';
import 'package:newjarvis/pages/screen_email.dart';
import 'package:newjarvis/providers/response_email_provider.dart';

class ScreenSetUpEmail extends StatefulWidget {
  const ScreenSetUpEmail({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ScreenSetUpEmail();
  }
}

class _ScreenSetUpEmail extends State<ScreenSetUpEmail> {
  // Controllers cho các TextField
  final TextEditingController contentController = TextEditingController();
  final TextEditingController mainIdeaController = TextEditingController();
  // Biến để lưu ngôn ngữ được chọn
  String? selectedLanguage;

  int selectedIndex = 0;
  int selectedSmallIndexLENGTH = -1;
  final List<String> listLength = ["Auto", "Short", "Medium", "Long"];

  int selectedSmallIndexFORMAT = -1;
  final List<String> listFormat = [
    "Auto",
    "Email",
    "Message",
    "Comment",
    "Paragraph",
    "Article",
    "Blog post",
    "Ideas",
    "Outline",
    "Twitter"
  ];

  int selectedSmallIndexTONE = -1;
  final List<String> listTone = [
    "Auto",
    "Amicable",
    "Casual",
    "Friendly",
    "Professional",
    "Witty",
    "Funny",
    "Formal"
  ];

  int selectedIndexSideBar = 3;
  bool isExpanded = false;
  bool isSidebarVisible = false;
  bool isDrawerVisible = false;
  double dragOffset = 200.0;

  // Default AI
  final AssistantModel _assistant = AssistantModel(
    id: Id.CLAUDE_3_HAIKU_20240307.value,
  );

  @override
  void dispose() {
    contentController.dispose();
    mainIdeaController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      isSidebarVisible = false;
    });
    // Navigate to the selected page
    RouteController.navigateTo(index);
  }

  void onGeneratePressed() async {
    if (contentController.text.trim().isEmpty ||
        mainIdeaController.text.trim().isEmpty ||
        selectedLanguage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields!')),
      );
      return;
    }

    // Chuẩn bị dữ liệu để gọi API
    final String content = contentController.text;
    final String mainIdea = mainIdeaController.text;
    final String length = (selectedSmallIndexLENGTH != -1)
        ? listLength[selectedSmallIndexLENGTH]
        : "Auto";
    final String format = (selectedSmallIndexFORMAT != -1)
        ? listFormat[selectedSmallIndexFORMAT]
        : "Auto";
    final String tone = (selectedSmallIndexTONE != -1)
        ? listTone[selectedSmallIndexTONE]
        : "Auto";
    final String language = selectedLanguage!;

    // In ra toàn bộ các giá trị
    print("Content: $content");
    print("Main Idea: $mainIdea");
    print("Length: $length");
    print("Format: $format");
    print("Tone: $tone");
    print("Language: $language");
    // Gọi API thông qua Provider
    final emailProvider = Provider.of<EmailProvider>(context, listen: false);

    try {
      // Chờ kết quả API call
      await emailProvider.generateEmail(
        model: _assistant.model,
        assistantId: _assistant.id!,
        email: content,
        action: "Reply to this email",
        mainIdea: mainIdea,
        context: [],
        subject: "No Subject",
        sender: "unknown@domain.com",
        receiver: "recipient@domain.com",
        length: length,
        formality: format,
        tone: tone,
        language: language,
        contextUI: context,
      );

      // Lấy kết quả từ Provider
      final response = emailProvider.emailResponse;

      // Điều hướng sang màn hình hiển thị email response và truyền dữ liệu
      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenEmail(
              emailResponse: response,
              emailContent: content,
              mainIdea: mainIdea,
              model: _assistant.model,
              assistantId: _assistant.id!,
              length: length,
              formality: format,
              tone: tone,
              language: language,

              // Truyền response sang màn hình Email
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate email response!')),
        );
      }
    } catch (error) {
      print("Error calling API: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBody(),
          _buildSideBarOrFloatingButton(),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 245, 242, 242),
    ));
  }

  Widget _buildSideBarOrFloatingButton() {
    if (isSidebarVisible) {
      return Positioned(
        top: 0,
        bottom: 0,
        right: 0,
        child: SideBar(
          isExpanded: isExpanded,
          selectedIndex: selectedIndexSideBar,
          onItemSelected: _onItemTapped,
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
      );
    } else {
      return FloatingButton(
        dragOffset: dragOffset,
        onDragUpdate: (delta) {
          setState(() {
            dragOffset += delta;
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
      );
    }
  }

  void _handleSelectedAI(BuildContext context, String aiId) {
    setState(() {
      _assistant.id = aiId;
    });

    // Fetch all conversations
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      title: Row(
        children: [
          /*const Text(
            "Email",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: "Times New Roman",
              fontSize: 23,
            ),
            textAlign: TextAlign.left,
          ),*/

          AiModelSelectionSection(
            onAiSelected: (String aiId) {
              _handleSelectedAI(context, aiId);
            },
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/icons/book.png",
                      width: 21,
                      height: 22,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Email Agent",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Arial",
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      elevation: 0,
      leading: null,
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    "Content you want to reply",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black),
                  )
                ],
              ),

              const SizedBox(height: 5.0),

              Container(
                height: 90,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(117, 231, 227, 227),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(children: [
                  TextField(
                    controller: contentController, // Gắn controller,
                    decoration: const InputDecoration(
                      hintText:
                          'Enter the text content you want AI to help answer',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontFamily: 'Arial',
                      ),
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                ]),
              ),

              const SizedBox(height: 11.0),

              const Row(
                children: [
                  Text(
                    "Main idea",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black),
                  )
                ],
              ),

              const SizedBox(height: 5.0),

              Container(
                height: 90,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(117, 231, 227, 227),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(children: [
                  TextField(
                    controller: mainIdeaController, // Gắn controller,
                    decoration: const InputDecoration(
                      hintText: 'Main idea of the answer you want to generate',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontFamily: 'Arial',
                      ),
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                ]),
              ),

              const SizedBox(height: 11.0),

              const Row(
                children: [
                  Text(
                    "Length",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black),
                  )
                ],
              ),

              const SizedBox(height: 5.0),

              // Length
              Align(
                  alignment: Alignment.centerLeft,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(4, (index) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSmallIndexLENGTH =
                                    (index >= 0 && index < listLength.length)
                                        ? index
                                        : -1;
                              });
                            },
                            child: IntrinsicWidth(
                                child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: selectedSmallIndexLENGTH == index
                                    ? Colors.blueAccent
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                listLength[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: "Arial",
                                  color: selectedSmallIndexLENGTH == index
                                      ? const Color.fromARGB(255, 0, 0, 0)
                                      : Colors.black,
                                ),
                              ),
                            )));
                      }),
                    );
                  })),

              const SizedBox(height: 21.0),

              const Row(
                children: [
                  Text(
                    "Format",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black),
                  )
                ],
              ),

              const SizedBox(height: 5.0),

              // Format
              Align(
                alignment: Alignment.centerLeft,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(10, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSmallIndexFORMAT =
                                  (index >= 0 && index < listFormat.length)
                                      ? index
                                      : -1;
                            });
                          },
                          child: IntrinsicWidth(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: selectedSmallIndexFORMAT == index
                                    ? Colors.blueAccent
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                listFormat[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: "Arial",
                                  color: selectedSmallIndexFORMAT == index
                                      ? const Color.fromARGB(255, 0, 0, 0)
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),

              const SizedBox(height: 21.0),

              const Row(
                children: [
                  Text(
                    "Tone",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black),
                  )
                ],
              ),

              const SizedBox(height: 5.0),

              // Tone
              Align(
                alignment: Alignment.centerLeft,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(8, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSmallIndexTONE =
                                  (index >= 0 && index < listTone.length)
                                      ? index
                                      : -1;
                            });
                          },
                          child: IntrinsicWidth(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: selectedSmallIndexTONE == index
                                    ? Colors.blueAccent
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                listTone[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: "Arial",
                                  color: selectedSmallIndexTONE == index
                                      ? const Color.fromARGB(255, 0, 0, 0)
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),

              const SizedBox(height: 11.0),

              const Row(
                children: [
                  Text(
                    "Output Language",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black),
                  )
                ],
              ),

              const SizedBox(height: 5.0),

              DropdownExample(
                onLanguageSelected: (String? value) {
                  setState(() {
                    selectedLanguage = value;
                  });
                },
              ),

              const SizedBox(height: 20.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: onGeneratePressed,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          width: 220,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade600.withOpacity(0.5),
                                offset: const Offset(0, 4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Generate Ctrl ⏎",
                              style: TextStyle(
                                fontFamily: "Arial",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

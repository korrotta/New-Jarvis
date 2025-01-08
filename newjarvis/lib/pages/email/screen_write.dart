import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:newjarvis/components/ai_chat/ai_model_selection_section.dart';
import 'package:newjarvis/components/email/language_component.dart';
import 'package:newjarvis/enums/id.dart';
import 'package:newjarvis/models/ai_chat/token_usage_model.dart';
import 'package:newjarvis/models/assistant/assistant_model.dart';
import 'package:newjarvis/pages/subscriptions/ad_helper.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:newjarvis/components/route/route_controller.dart';
import 'package:newjarvis/components/widgets/floating_button.dart';
import 'package:newjarvis/components/widgets/side_bar.dart';
import 'package:newjarvis/pages/email/screen_email.dart';
import 'package:newjarvis/providers/email_provider/response_email_provider.dart';

class ScreenSetUpEmail extends StatefulWidget {
  const ScreenSetUpEmail({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ScreenSetUpEmail();
  }
}

class _ScreenSetUpEmail extends State<ScreenSetUpEmail> {
  String _remainingUsage = '0';
  final ApiService _apiService = ApiService();

  // Controllers cho các TextField
  final TextEditingController contentController = TextEditingController();
  final TextEditingController mainIdeaController = TextEditingController();
  // Biến để lưu ngôn ngữ được chọn
  String? selectedLanguage;

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

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
      selectedIndexSideBar = index;
      isSidebarVisible = false;
    });
    // Navigate to the selected page
    RouteController.navigateTo(index);
  }

  @override
  void initState() {
    super.initState();
    _fetchRemainingUsage();
    BannerAd (
      adUnitId: AdHelper.BannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,  
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        }
        )

      ).load();

      InterstitialAd.load (
      adUnitId: AdHelper.InterstatialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad){
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {});
        }, 
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        }
      ),
      );
  }

  // Fetch remaining usage
  Future<void> _fetchRemainingUsage() async {
    try {
      final TokenUsageModel tokenUsage = await _apiService.getTokenUsage();
      setState(() {
        if (tokenUsage.unlimited == true) {
          _remainingUsage = 'Unlimited';
        } else {
          _remainingUsage = tokenUsage.remainingTokens;
        }
      });
    } catch (e) {
      // Error fetching remaining tokens
    }
  }

  // Hàm xây dựng biểu tượng ngọn lửa kèm số
  Widget _buildFireBadge(String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // Nền màu sáng
        borderRadius: BorderRadius.circular(15.0), // Bo góc
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4.0, // Hiệu ứng bóng mờ
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/fire_blue.png", // Thay bằng đường dẫn icon ngọn lửa của bạn
            width: 17,
            height: 17,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10), // Khoảng cách giữa icon và số
          Text(
            count,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  void onGeneratePressed() async {

    _interstitialAd?.show();

    if (contentController.text.trim().isEmpty ||
        mainIdeaController.text.trim().isEmpty ||
        selectedLanguage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields!')),
      );
      return;
    }

   

    // Hiển thị loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Không cho phép đóng dialog khi nhấn ra ngoài
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

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

      // Đóng loading dialog
      Navigator.of(context).pop();

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
            if(_bannerAd != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
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
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(
          136, 200, 200, 200), // .fromRGBO(238, 238, 238, 1),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AiModelSelectionSection(
            onAiSelected: (String aiId) {
              _handleSelectedAI(context, aiId);
            },
          ),
          const SizedBox(width: 30),
          _buildFireBadge(_remainingUsage),
          /*Expanded(
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
          ),*/
        ],
      ),
      elevation: 0,
      automaticallyImplyLeading: false,
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
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.3, // Giới hạn chiều cao tối đa
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(117, 231, 227, 227),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: SingleChildScrollView(
                  child: TextField(
                    controller: contentController,
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
                    keyboardType: TextInputType.multiline,
                    maxLines: null, // Cho phép nhập nhiều dòng
                    scrollPhysics:
                        const BouncingScrollPhysics(), // Cuộn nội dung
                  ),
                ),
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
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.3, // Giới hạn chiều cao tối đa
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(117, 231, 227, 227),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: SingleChildScrollView(
                  child: TextField(
                    controller: mainIdeaController,
                    decoration: const InputDecoration(
                      hintText: 'Main idea of the answer you want to generate',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontFamily: 'Arial',
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null, // Cho phép nhập nhiều dòng
                    scrollPhysics:
                        const BouncingScrollPhysics(), // Cuộn nội dung
                  ),
                ),
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

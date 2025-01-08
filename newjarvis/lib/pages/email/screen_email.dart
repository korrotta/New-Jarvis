
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newjarvis/components/email/draft_email_component.dart';
import 'package:newjarvis/models/email/response_email_model.dart';
import 'package:newjarvis/providers/email_provider/idea_email_provider.dart';
import 'package:newjarvis/providers/email_provider/response_email_provider.dart';
import 'package:provider/provider.dart';

class ScreenEmail extends StatefulWidget {
  final EmailResponseModel emailResponse;
  final String emailContent;
  final String mainIdea;
  final String model;
  final String assistantId;
  final String length;
  final String formality;
  final String tone;
  final String language;

  const ScreenEmail({
    required this.emailResponse,
    required this.emailContent,
    required this.mainIdea,
    required this.model,
    required this.assistantId,
    required this.length,
    required this.formality,
    required this.tone,
    required this.language,
    super.key,
  });

  @override
  State<ScreenEmail> createState() {
    return _ScreenEmailState();
  }
}

class _ScreenEmailState extends State<ScreenEmail> {
  final List<Widget> _chatWidgets = [];
  final TextEditingController _chatController = TextEditingController();
  bool _isOptionVisible = true;

  late int _fireCount = widget.emailResponse.remainingUsage;
  
  final ScrollController _scrollController = ScrollController();

  final List<String> _chatData = [];


  @override
  void initState() {
    super.initState();
  // Hiển thị emailContent đầu tiên
  _chatWidgets.add(_buildEmailContentReceived(widget.emailContent));
  _chatData.add(widget.emailContent); // Đồng bộ _chatData

  // Hiển thị mainIdea từ emailContent
  _chatWidgets.add(_buildUserChat(widget.mainIdea));
  _chatData.add(widget.mainIdea); // Đồng bộ _chatData

  // Hiển thị phản hồi AI đầu tiên
  _chatWidgets.add(_buildAIReply(widget.emailResponse.email));
  _chatData.add(widget.emailResponse.email); // Đồng bộ _chatData
  

  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> onGenerateEmailIdeaDraft() async {
  // Gọi API thông qua Provider
  final emailIdeaProvider =
      Provider.of<EmailDraftIdeaProvider>(context, listen: false);

  try {
    // Chờ kết quả API call
    await emailIdeaProvider.generateEmailIdea(
      model: widget.model,
      assistantId: widget.assistantId,
      email: widget.emailContent,
      action: "Suggest 3 ideas for this email",
      context: [],
      subject: "No Subject",
      sender: "unknown@domain.com",
      receiver: "recipient@domain.com",
      language: widget.language,
      contextUI: context,
    );

    // Lấy kết quả từ Provider
    final responseDraft = emailIdeaProvider.emailResponse;

    // Đóng dialog trước khi chuyển trang
    Navigator.of(context).pop();

    // Điều hướng sang màn hình hiển thị email response và truyền dữ liệu
    if (responseDraft != null) {
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DraftEmailPage(
            draftReplies: responseDraft.ideas,
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

  

  // Hàm để gọi API và thêm reply mới
  Future<void> _handleSendMessage() async {
    final String newMainIdea = _chatController.text.trim();
    if (newMainIdea.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message!')),
      );
      return;
    }

    // Thêm nội dung mới của người dùng (màu xanh)
    setState(() {
      _chatWidgets.add(_buildUserChat(newMainIdea));
      _chatData.add(newMainIdea);
      
      _isOptionVisible = false;
      _chatController.clear();
    });
    // Cuộn xuống cuối sau khi thêm tin nhắn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Gọi API để lấy reply mới từ AI
    try {
      // Thay bằng hàm gọi API thực tế của bạn
      final newAIResponse = await _onGenerateContinue(newMainIdea);

      if (newAIResponse != null) {
      setState(() {
        _chatWidgets.add(_buildAIReply(newAIResponse.email)); // Truy cập email nếu không null
        _chatData.add(newAIResponse.email);
        _fireCount = newAIResponse.remainingUsage;
        _isOptionVisible = true;
      });
      // Đảm bảo cuộn xuống sau khi AI Reply được thêm
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to generate response!')),
    );
  }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  Future<EmailResponseModel?> _onGenerateContinue(String newMainIdea) async {

  // Gọi API thông qua Provider
  final emailProvider = Provider.of<EmailProvider>(context, listen: false);


  try {
    // Chờ kết quả API call
    await emailProvider.generateEmail(
      model: widget.model, 
      assistantId: widget.assistantId,
      email: widget.emailContent,
      action: "Reply to this email",
      mainIdea: newMainIdea,
      context: [], 
      subject: "No Subject",
      sender: "unknown@domain.com",
      receiver: "recipient@domain.com", 
      length: widget.length,
      formality: widget.formality,
      tone: widget.tone,
      language: widget.language,
      contextUI: context,
    );

    // Lấy kết quả từ Provider
    final response = emailProvider.emailResponse;

    return response;
  } catch (error) {
    print("Error generating email: $error");
    return null;
  }
}


Widget _buildUserChat(String content) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    width: double.infinity,
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: const Color.fromARGB(235, 210, 227, 252), // Nền xanh dương nhạt
      borderRadius: BorderRadius.circular(15.0), // Góc bo tròn
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 10.0, // Độ mờ của shadow
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(color: Colors.blue.shade300, width: 1.5), // Viền xanh nhẹ
    ),
    child: Text(
      content,
      style: GoogleFonts.openSans(
        textStyle: const TextStyle(
          fontSize: 14.0,
          color: Colors.black87, // Màu chữ đen nhạt
          height: 1.5, // Khoảng cách dòng thoải mái
        ),
      ),
      textAlign: TextAlign.left, // Canh trái nội dung
    ),
  );
}


Widget _buildEmailContentReceived(String content) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    width: double.infinity,
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white, // Nền trắng chủ đạo
      borderRadius: BorderRadius.circular(15.0), // Góc bo tròn
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 10.0, // Độ mờ của shadow
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(color: Colors.orange.shade200, width: 1.5), // Viền cam nhẹ
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề "EmailContent Received"
        Text(
          "Content Received",
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFB8C00), // Màu cam đậm
            ),
          ),
        ),
        const SizedBox(height: 8.0),

        // Nội dung email
        Text(
          content,
          style: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
              height: 1.5, // Khoảng cách giữa các dòng
            ),
          ),
          textAlign: TextAlign.left, // Canh trái nội dung
        ),
      ],
    ),
  );
}


Widget _buildAIReply(String content) {
  
  return  Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.blue.shade100, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề "Jarvis reply"
          Text(
            "Jarvis reply",
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5), // Màu xanh chủ đạo
              ),
            ),
          ),
          const SizedBox(height: 8.0),

          // Nội dung câu trả lời
          Text(
            content,
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
                height: 1.5, // Khoảng cách dòng
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // Divider
          Divider(color: Colors.grey.shade300, thickness: 1),

          // Các nút bổ trợ (Copy và Refresh)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Nút Copy
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: content));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã copy!')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.content_copy_outlined,
                          size: 20, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Nút Refresh
                  GestureDetector(
                    onTap: () async {
                      await _handleRefreshReply(content);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.refresh,
                          size: 22, color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
  );
}

  ///////////////////

  Future<void> _handleRefreshReply(String currentReply) async {
  // Tìm chỉ số của reply hiện tại trong _chatData
  final int replyIndex = _chatData.indexOf(currentReply);

  // Nếu không tìm thấy reply, thông báo lỗi
  if (replyIndex == -1) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Không tìm thấy reply để refresh!')),
    );
    return;
  }

  // Lấy nội dung từ ô phía trên
  final int aboveIndex = replyIndex - 1;
  if (aboveIndex < 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Không có nội dung phía trên để làm mới!')),
    );
    return;
  }

  final String contentToSend = _chatData[aboveIndex];

  try {
    // Gọi API để tạo reply mới
    final EmailResponseModel? newReply = await _onGenerateContinue(contentToSend);

    if (newReply == null || newReply.email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tạo reply mới!')),
      );
      return;
    }

    // Cập nhật reply mới
    setState(() {
      _fireCount = newReply.remainingUsage;
      _chatWidgets[replyIndex] = _buildAIReply(newReply.email);
      _chatData[replyIndex] = newReply.email; // Cập nhật dữ liệu
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã làm mới reply!')),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lỗi khi refresh: $error')),
    );
  }
}








  Widget _buildOptionEmail() {
  final List<String> options = [
    "🙏 Thanks",
    "😔 Sorry",
    "👍 Yes",
    "👎 No",
    "🗓️ Follow up",
    "🤔 Request for more information"
  ];

  return Align(
    alignment: Alignment.centerLeft,
    child: Wrap(
      spacing: 8.0, // Khoảng cách ngang giữa các nút
      runSpacing: 8.0, // Khoảng cách dọc giữa các dòng nút
      children: List.generate(
        options.length,
        (index) => GestureDetector(
          onTap: () {
            setState(() {
              final selectedOption = options[index];
              _chatController.text = selectedOption;
            });
            _handleSendMessage(); // Gửi UserChat ngay khi bấm nút
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(169, 192, 226, 255), // Nền xanh nhạt
              borderRadius: BorderRadius.circular(8.0), // Góc bo tròn
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100,
                  blurRadius: 4.0,
                  offset: const Offset(0, 2), // Bóng nhẹ xuống dưới
                ),
              ],
              border: Border.all(
                color: Colors.blue.shade200,
                width: 1.0,
              ),
            ),
            child: Text(
              options[index],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color.fromARGB(255, 26, 115, 232), // Màu chữ xanh đậm
              ),
            ),
          ),
        ),
      ),
    ),
  );
}


  Widget _buildBottomChat() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        top: BorderSide(color: Colors.grey.shade300),
      ),
    ),
    child: Row(
      children: [
        // Icon bóng đèn (idea)
        GestureDetector(
          onTap: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              await onGenerateEmailIdeaDraft();
            },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: Colors.orange,
              size: 24.0,
            ),
          ),
        ),
        const SizedBox(width: 10.0),

        // Hộp nhập chat
        Expanded(
          child: TextField(
            controller: _chatController,
            decoration: InputDecoration(
              hintText: 'Tell Jarvis how you want to reply...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10.0),

        // Nút gửi (send)
        GestureDetector(
          onTap: _handleSendMessage,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200,
                  blurRadius: 6.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 20.0,
            ),
          ),
        ),
      ],
    ),
  );
}


  AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
    title: Row(
      children: [
        const Text(
          "Email",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: "Times New Roman",
            fontSize: 23,
          ),
          textAlign: TextAlign.left,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  _buildFireBadge(_fireCount), // Gọi hàm hiển thị ngọn lửa
                  
                  const SizedBox(width: 10),
                  
                  /*Image.asset(
                    "assets/icons/book.png",
                    width: 22,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "Email Agent",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Arial",
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),*/
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

// Hàm xây dựng biểu tượng ngọn lửa kèm số
Widget _buildFireBadge(int count) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
          width: 18,
          height: 18,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 10), // Khoảng cách giữa icon và số
        Text(
          "$count", // Hiển thị số integer
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ],
    ),
  );
}

void _scrollToBottom() {
  Future.delayed(const Duration(milliseconds: 100), () {
    if (_scrollController.hasClients) {
      debugPrint("MaxScrollExtent: ${_scrollController.position.maxScrollExtent}");
      debugPrint("Current position: ${_scrollController.position.pixels}");
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      debugPrint("ScrollController không hoạt động.");
    }
  });
}



@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 242, 242),
      appBar: _buildAppBar(),
      resizeToAvoidBottomInset: true, 
      body: Column(
        children: [

          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              children: [
                ..._chatWidgets,
                const SizedBox(height: 10),
                if (_isOptionVisible) _buildOptionEmail(),
              ],
            ),
          ),
        ],
      ),
      // Điều chỉnh bottomNavigationBar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8.0,
              offset: const Offset(0, -4), 
            ),
          ],
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0, 
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildBottomChat()),
            ],
          ),
        ),
      ),
    ),
  );
}


}

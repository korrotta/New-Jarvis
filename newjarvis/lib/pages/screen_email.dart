import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newjarvis/models/response_email_model.dart';
import 'package:newjarvis/providers/response_email_provider.dart';
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
  

  @override
  void initState() {
    super.initState();
    // Khởi tạo giao diện khi mới vào
      super.initState();
  // Hiển thị emailContent đầu tiên
  _chatWidgets.add(_buildEmailContentReceived(widget.emailContent));
  // Hiển thị mainIdea từ emailContent
  _chatWidgets.add(_buildUserChat(widget.mainIdea));
  // Hiển thị phản hồi AI đầu tiên
  _chatWidgets.add(_buildAIReply(widget.emailResponse.email));

  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
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
      _isOptionVisible = false;
      _chatController.clear();
    });

    // Gọi API để lấy reply mới từ AI
    try {
      // Thay bằng hàm gọi API thực tế của bạn
      final newAIResponse = await _onGenerateContinue(newMainIdea);

      setState(() {
        _chatWidgets.add(_buildAIReply(newAIResponse));
        _isOptionVisible = true;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  Future<String> _onGenerateContinue(String newMainIdea) async {

  // Gọi API thông qua Provider
  final emailProvider = Provider.of<EmailProvider>(context, listen: false);
  await Future.delayed(const Duration(seconds: 2)); // Mô phỏng thời gian chờ

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
      // ignore: use_build_context_synchronously
      contextUI: context,
    );

    // Lấy kết quả từ Provider
    final response = emailProvider.emailResponse;
  // Đảm bảo trả về chuỗi nội dung từ phản hồi của API
    return response?.email ?? "No response from API";
  } catch (error) {
    print("Error generating email: $error");
    return "Error: $error";
  }
}

  Widget _buildUserChat(String content) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(235, 210, 227, 252),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildEmailContentReceived(String content) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 220, 220, 220), // Màu xám nhạt cho emailContent Received
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "EmailContent Received",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    ),
  );
}


  Widget _buildAIReply(String content) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Jarvis reply",
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 26, 115, 232),
          ),
        ),
        const Divider(),
        Text(
          content,
          style: const TextStyle(fontSize: 14.0),
        ),
        const Divider(),
        const SizedBox(height: 12),

        // Các nút bổ trợ
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
                  child: const Icon(Icons.content_copy_outlined, size: 20),
                ),
                const SizedBox(width: 12),

                // Nút Refresh
                GestureDetector(
                  onTap: () async {
                    await _handleRefreshReply(content);
                  },
                  child: const Icon(Icons.refresh, size: 22),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}


  Future<void> _handleRefreshReply(String currentReply) async {
  final int replyIndex = _chatWidgets.indexWhere((widget) {
    if (widget is Container && widget.child is Column) {
      final Column column = widget.child as Column;
      final Text? replyText = column.children
          .whereType<Text>()
          .firstWhere(
            (child) => child.data == currentReply,
            orElse: () => const Text(""),
          );
      return replyText?.data == currentReply;
    }
    return false;
  });

  if (replyIndex == -1) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Không tìm thấy reply để refresh!')),
    );
    return;
  }

  // Nếu reply đầu tiên, sử dụng emailContent Received
  final int aboveIndex = replyIndex - 1;
  String contentToSend = "";

  if (aboveIndex == 0) {
    contentToSend = widget.mainIdea; // Dùng mainIdea từ widget
  } else {
    final Container aboveWidget = _chatWidgets[aboveIndex] as Container;
    contentToSend = (aboveWidget.child is Text)
        ? (aboveWidget.child as Text).data ?? ""
        : "";
  }

  if (contentToSend.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Không thể lấy nội dung phía trên!')),
    );
    return;
  }

  // Gọi API để lấy reply mới
  final String newReply = await _onGenerateContinue(contentToSend);

  // Cập nhật nội dung reply mới
  setState(() {
    _chatWidgets[replyIndex] = _buildAIReply(newReply);
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Đã làm mới reply!')),
  );
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
        spacing: 8.0,
        runSpacing: 8.0,
        children: List.generate(
          options.length,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                _chatController.text = options[index];
              });
            },
            child: IntrinsicWidth(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(169, 192, 226, 255),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  options[index],
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: Color.fromARGB(255, 26, 115, 232),
                  ),
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
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatController,
              decoration: InputDecoration(
                hintText: 'Tell Jarvis how you want to reply...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _handleSendMessage,
          ),
        ],
      ),
    );
  }

   AppBar _buildAppBar(){
    return 
      AppBar(
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        title: 
        Row(
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

@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 242, 242),
      appBar: _buildAppBar(),
      resizeToAvoidBottomInset: true, // Đảm bảo resize khi bàn phím hiện lên
      body: Column(
        children: [
          // Nội dung chính của màn hình
          Expanded(
            child: ListView(
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Đẩy lên khi bàn phím xuất hiện
        ),
        child: _buildBottomChat(),
      ),
    ),
  );
}


}

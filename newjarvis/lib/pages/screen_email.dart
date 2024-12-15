import 'package:flutter/material.dart';

class ScreenEmail extends StatefulWidget {
  const ScreenEmail({super.key});

  @override
  State<ScreenEmail> createState() {
    return _ScreenEmailState();
  }
}

class _ScreenEmailState extends State<ScreenEmail> {
  int selectedSmallIndexLength = -1;
  final List<String> listLength = [
    "🙏 Thanks",
    "😔 Sorry",
    "👍Yes",
    "👎 No",
    "🗓️ Follow up",
    "🤔 Request for more information"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 242, 242),
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomChat(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      title: const Text(
        "Email reply",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: "Times New Roman"),
        textAlign: TextAlign.left,
        textScaleFactor: 1.3,
      ),
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          children: [
            _buildUserChat(),
            const SizedBox(height: 10.0),
            _buildAIReply(),
            const SizedBox(height: 10.0),
            _buildOptionEmail(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserChat() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(235, 210, 227, 252), // Nền màu xanh nhạt
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Text(
        "Chào Hiếu!\n\nNếu bạn quan tâm, hãy cho tôi biết và chúng ta có thể thảo luận thêm về kế hoạch.\n\nChúc bạn một ngày tốt lành!\nSuhao,",
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }

  Widget _buildAIReply() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white, // Nền màu trắng cho AI
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề trả lời của AI
          Text(
            "Jarvis reply",
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue),
          ),
          Divider(),
          // Nội dung trả lời của AI
          Text(
            "Chào Suhao!\n\nCảm ơn bạn đã mời tôi tham gia cùng bạn vào cuối tuần này. Tuy nhiên, tôi rất tiếc không thể tham gia được vì đã có kế hoạch khác vào thời điểm đó. Mong rằng bạn sẽ có một chuyến đi thú vị và đầy ý nghĩa. Chúc bạn một ngày tốt lành!\n\nThân ái!\nHiếu",
            style: TextStyle(fontSize: 14.0),
          ),
          Divider(),
          // Các nút bổ trợ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.insert_emoticon, size: 18),
                  SizedBox(width: 8),
                  Icon(Icons.copy, size: 18),
                  SizedBox(width: 8),
                  Icon(Icons.refresh, size: 18),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_back, size: 18),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionEmail() {
    return // Length
        Align(
            alignment: Alignment.centerLeft,
            child: LayoutBuilder(builder: (context, constraints) {
              return Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: List.generate(6, (index) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSmallIndexLength =
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
                          color: selectedSmallIndexLength == index
                              ? const Color.fromARGB(255, 202, 172, 241)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          listLength[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: "Arial",
                            color: selectedSmallIndexLength == index
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : Colors.black,
                          ),
                        ),
                      )));
                }),
              );
            }));
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
              decoration: InputDecoration(
                hintText: 'Tell Jarvis how you want to reply...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              // Xử lý khi nhấn gửi
            },
          ),
          const SizedBox(width: 8.0),
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: const Color.fromARGB(235, 240, 233, 233),
              borderRadius: BorderRadius.circular(35.0),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 7.0),
                  // Sử dụng Image.asset để hiển thị hình ảnh avatar
                  Image.asset(
                    'assets/icons/icon.png', // Đường dẫn tới ảnh
                    width: 20.0, // Kích thước của ảnh
                    height: 20.0,
                  ),
                  const SizedBox(width: 3.0),

                  Transform.translate(
                    offset: const Offset(0, -3.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 22,
                      onPressed: () {
                        // Xử lý khi nhấn dropdown
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DraftEmailPage extends StatelessWidget {
  final List<String> draftReplies;

  const DraftEmailPage({required this.draftReplies, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
          title: const Text(
            "Draft Email",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: "Times New Roman",
              fontSize: 23,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        backgroundColor: const Color.fromARGB(255, 245, 242, 242),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          itemCount: draftReplies.length,
          itemBuilder: (context, index) {
            return _buildDraftReply(draftReplies[index], context);
          },
        ),
      ),
    );
  }

  Widget _buildDraftReply(String content, BuildContext context) {
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
            "Draft Reply",
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
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: content));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Draft reply copied!')),
                );
              },
              child: const Icon(Icons.content_copy_outlined, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

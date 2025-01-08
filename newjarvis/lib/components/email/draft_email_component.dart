import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class DraftEmailPage extends StatelessWidget {
  final List<String> draftReplies;

  const DraftEmailPage({required this.draftReplies, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
          title: Text(
            "Draft Email",
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.blue.shade100, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Draft Reply",
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            content,
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: content));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Draft reply copied!')),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.content_copy_outlined, size: 20, color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

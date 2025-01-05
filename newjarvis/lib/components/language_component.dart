import 'package:flutter/material.dart';

class DropdownExample extends StatefulWidget {
  final Function(String?) onLanguageSelected; // Callback để gửi ngôn ngữ đã chọn ra ngoài

  const DropdownExample({super.key, required this.onLanguageSelected});

  @override
  State<DropdownExample> createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade400, width: 0.8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedLanguage,
            icon: const Icon(Icons.arrow_drop_down, size: 16),
            items: const [
              DropdownMenuItem(
                value: "English",
                child: Text(
                  "English",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              DropdownMenuItem(
                value: "Vietnamese",
                child: Text(
                  "Vietnamese",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
            onChanged: (String? value) {
              setState(() {
                selectedLanguage = value;
              });

              widget.onLanguageSelected(value); // Gửi ngôn ngữ đã chọn qua callback
            },
            hint: const Text(
              "Select Language",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    );
  }
}
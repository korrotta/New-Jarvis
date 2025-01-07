import 'package:flutter/material.dart';

class SelectMethodDialog extends StatefulWidget {
  final Function(String) onMethodSelected;

  const SelectMethodDialog({required this.onMethodSelected, super.key});

  @override
  State<SelectMethodDialog> createState() => _SelectMethodDialogState();
}

class _SelectMethodDialogState extends State<SelectMethodDialog> {
  String _selectedMethod = "Local Files"; 

  final List<Map<String, dynamic>> methods = [
  {"name": "Local Files", "description": "Upload pdf, docx,...", "iconPath": 'assets/icons/iconLocalfile.png'},
  {"name": "Website", "description": "Website to get data", "iconPath": 'assets/icons/iconWeb.png'},
  {"name": "Google Drive", "description": "GG Drive to get data", "iconPath": 'assets/icons/iconDrive.png'},
  {"name": "Slack", "description": "Slack to get data", "iconPath": 'assets/icons/iconSlack.png'},
  {"name": "Confluence", "description": "Confluence to get data", "iconPath": 'assets/icons/iconConfluence.png'},
];


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Unit'),
      content: SingleChildScrollView(
        child: Column(
          children: methods.map((method) {
            final isSelected = _selectedMethod == method["name"];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMethod = method["name"];
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade50 : Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    method.containsKey("iconPath")
                    ? Image.asset(method["iconPath"], width: 30, height: 30)
                    : Icon(
                        method["iconData"],
                        color: isSelected ? Colors.blue : Colors.blue,
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method["name"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.black : Colors.black,
                            ),
                          ),
                          Text(
                            method["description"],
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        // Nút Cancel
        TextButton(
          onPressed: () {
            Navigator.pop(context); 
          },
          child: const Text('Cancel'),
        ),
        // Nút Next
        ElevatedButton(
          onPressed: () {
          // Đóng dialog hiện tại và mở dialog mới sau khi dialog này đóng
          Navigator.of(context).pop();
          Future.delayed(Duration.zero, () {
            widget.onMethodSelected(_selectedMethod);
          });
            
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
          ),
          child: const Text('Next', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
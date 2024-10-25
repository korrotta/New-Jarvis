import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const CustomButton({
    Key? key,
    required this.label,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18, color: Colors.black),
      label: Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
      onPressed: onPressed,
    );
  }
}

class LanguageDropdown extends StatefulWidget {
  final String initialSelection;
  final ValueChanged<String> onSelect;

  const LanguageDropdown({
    Key? key,
    required this.initialSelection,
    required this.onSelect,
  }) : super(key: key);

  @override
  _LanguageDropdownState createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialSelection;
  }

  void _openLanguageSelectionDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return LanguageSelectionDialog(
          onSelect: (lang) {
            Navigator.pop(context, lang);
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedLanguage = result;
      });
      widget.onSelect(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openLanguageSelectionDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedLanguage,
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

class LanguageSelectionDialog extends StatefulWidget {
  final ValueChanged<String> onSelect;

  const LanguageSelectionDialog({Key? key, required this.onSelect})
      : super(key: key);

  @override
  _LanguageSelectionDialogState createState() =>
      _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
  final List<String> languages = [
    'English',
    'French',
    'Indonesian',
    'Malay',
    'Catalan',
    'Czech',
    'Spanish',
  ];
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredLanguages = languages
        .where((lang) =>
            lang.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredLanguages.length,
                itemBuilder: (context, index) {
                  final lang = filteredLanguages[index];
                  return ListTile(
                    title: Text(lang),
                    onTap: () {
                      widget.onSelect(lang);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextArea extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final double height;
  final Color backgroundColor;

  const CustomTextArea({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    required this.height,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade300),
      ),
      child: Stack(
        children: [
          // Text Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
          
          // Bottom Left Icons
          Positioned(
            bottom: 8,
            left: 8,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(icon, size: 20, color: Colors.grey),
                  onPressed: () {
                    // Handle icon action (e.g., mic or volume)
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20, color: Colors.grey),
                  onPressed: () {
                    // Handle copy action
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PdfTranslationDialog extends StatelessWidget {
  const PdfTranslationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'PDF Translation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Translate a PDF file and compare it side by side '
              'with the original file on the left and the translated file on the right.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Handle file upload logic
              },
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_upload_outlined, size: 50, color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text(
                      'Click or drag and drop here to upload',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'File types supported: PDF | Max file size: 50MB',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebTranslationDialog extends StatelessWidget {
  const WebTranslationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Web Translation Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Source Language Dropdown
            buildLanguageDropdown('Source:'),
            const SizedBox(height: 10),

            // Target Language Dropdown
            buildLanguageDropdown('Target:'),
            const SizedBox(height: 20),

            // Settings Options with Checkboxes
            buildCheckboxOption('Auto Translate Current Site:'),
            buildCheckboxOption('Auto Translate English:'),
            buildCheckboxOption('Never Translate Current Site:'),
            buildCheckboxOption('Auto Show Translate Button:'),
            buildCheckboxOption('Translation Display Underline:'),
          ],
        ),
      ),
    );
  }

  Widget buildLanguageDropdown(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        DropdownButton<String>(
          value: 'Auto Detect',
          items: <String>['Auto Detect', 'English', 'Vietnamese']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            // Handle language selection
          },
        ),
      ],
    );
  }

  Widget buildCheckboxOption(String label) {
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (bool? value) {
            // Handle checkbox change
          },
        ),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}


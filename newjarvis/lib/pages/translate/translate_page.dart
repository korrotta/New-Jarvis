import 'package:newjarvis/components/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class TranslatePage extends StatelessWidget {
  const TranslatePage({Key? key}) : super(key: key);

  void _openPdfDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const PdfTranslationDialog(); // Open PDF translation dialog
      },
    );
  }

  void _openWebTranslationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const WebTranslationDialog(); // Open Web Translation Settings dialog
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Top Bar Section
            Padding(
              padding: const EdgeInsets.only(
                top: 40.0, // Adjust for status bar
                left: 16.0,
                right: 16.0,
                bottom: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Translate',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune, color: Colors.black),
                    onPressed: () {
                      // Handle settings
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row for PDF and Web Translation Buttons
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 20,
                    runSpacing: 10,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        label: 'PDF Translation',
                        icon: Icons.picture_as_pdf,
                        onPressed: () => _openPdfDialog(context),
                      ),
                      CustomButton(
                        label: 'Web Translation',
                        icon: Icons.web,
                        onPressed: () => _openWebTranslationDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Input Language Dropdown
                  LanguageDropdown(
                    initialSelection: 'Vietnamese - Detected',
                    onSelect: (lang) {
                      // Handle input language selection
                    },
                  ),
                  const SizedBox(height: 10),

                  // Input Text Area
                  CustomTextArea(
                    hintText: 'Enter text',
                    icon: Icons.mic,
                    onChanged: (value) {
                      // Handle text input
                    },
                    height: 150,
                    backgroundColor: Colors.grey.shade100,
                  ),
                  const SizedBox(height: 20),

                  // Swap Button between input and output
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.swap_vert,
                          size: 30, color: Colors.grey),
                      onPressed: () {
                        // Handle swap functionality
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Output Language Dropdown
                  LanguageDropdown(
                    initialSelection: 'English',
                    onSelect: (lang) {
                      // Handle output language selection
                    },
                  ),
                  const SizedBox(height: 10),

                  // Output Text Area
                  CustomTextArea(
                    hintText: 'Translation',
                    icon: Icons.volume_up,
                    onChanged: (value) {
                      // Handle output text (if editable)
                    },
                    height: 150,
                    backgroundColor: Colors.grey.shade100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

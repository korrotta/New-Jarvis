import 'package:flutter/material.dart';
import 'package:newjarvis/services/api_service.dart';

class NewPromptDialog extends StatefulWidget {
  final void Function() refresh;

  const NewPromptDialog({super.key, required this.refresh});
  @override
  _NewPromptDialogState createState() => _NewPromptDialogState();
}

class _NewPromptDialogState extends State<NewPromptDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPrivatePrompt = true; // Default to "Private Prompt"

  String selectedLanguage = "Auto"; // Default language selection
  String selectedCategory = "Other"; // Default category selection

  final TextEditingController nameController = TextEditingController();
  final TextEditingController promptController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> onSubmit() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Get the input data
      final newPrompt = {
        "title": nameController.text.trim(),
        "content": promptController.text.trim(),
        "description": descriptionController.text.isEmpty
            ? "Custom prompt created by the user"
            : descriptionController.text.trim(),
        "category": 'other',
        "language": selectedLanguage,
        "isPublic": !isPrivatePrompt, // Negate since "Private Prompt" is true
      } as Map<String, dynamic>;

      try {
        // Call the ApiService to create the prompt
        final response = await ApiService.instance.createPrompt(
          context: context,
          title: newPrompt["title"]!,
          content: newPrompt["content"]!,
          description: newPrompt["description"]!,
          category: newPrompt["category"]!,
          language: newPrompt["language"]!,
          isPublic: newPrompt["isPublic"]!,
        );

        // Handle success
        if (response.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prompt created successfully!')),
          );
          widget.refresh(); // Refresh the prompt list
          Navigator.of(context).pop(); // Close dialog
        }
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating prompt: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 600, // Adjust width as needed
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  "New Prompt",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Prompt Type (Private/Public)
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        value: true,
                        groupValue: isPrivatePrompt,
                        onChanged: (value) {
                          setState(() {
                            isPrivatePrompt = value as bool;
                          });
                        },
                        title: const Text(
                          "Private Prompt",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        value: false,
                        groupValue: isPrivatePrompt,
                        onChanged: (value) {
                          setState(() {
                            isPrivatePrompt = value as bool;
                          });
                        },
                        title: const Text(
                          "Public Prompt",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Name Field (Always Visible)
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name *",
                    hintText: "Name of the prompt",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name is required.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Fields for Public Prompt Only
                if (!isPrivatePrompt) ...[
                  DropdownButtonFormField<String>(
                    value: selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Prompt Language *",
                      border: OutlineInputBorder(),
                    ),
                    items: ["Auto", "English", "Spanish", "French", "German"]
                        .map((language) => DropdownMenuItem(
                              value: language,
                              child: Text(language),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Language is required.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Category *",
                      border: OutlineInputBorder(),
                    ),
                    items: ["Other", "Grammar", "Creative Writing", "Science"]
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Category is required.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      hintText:
                          "Describe your prompt so others can have a better understanding",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Description is required.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Prompt Field (Always Visible)
                TextFormField(
                  controller: promptController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Prompt *",
                    hintText: "e.g. Write an article about [TOPIC]",
                    border: OutlineInputBorder(),
                    helperText:
                        "Use square brackets [ ] to specify user input.",
                    helperStyle: TextStyle(color: Colors.blue),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Prompt is required.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Create"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

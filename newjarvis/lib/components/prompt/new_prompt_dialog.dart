import 'package:flutter/material.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:newjarvis/states/category_state.dart';
import 'package:provider/provider.dart';

class NewPromptDialog extends StatefulWidget {
  final void Function() refresh;

  const NewPromptDialog({super.key, required this.refresh});

  @override
  _NewPromptDialogState createState() => _NewPromptDialogState();
}

class _NewPromptDialogState extends State<NewPromptDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPrivatePrompt = true;

  String selectedLanguage = "Auto";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController promptController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final categoryState = Provider.of<CategoryState>(context, listen: false);
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);
  
      final newPrompt = {
        "title": nameController.text.trim(),
        "content": promptController.text.trim(),
        "description": descriptionController.text.isEmpty
            ? "Custom prompt created by the user"
            : descriptionController.text.trim(),
        "category": categoryState.selectedCategory,
        "language": selectedLanguage,
        "isPublic": !isPrivatePrompt,
      };
  
      try {
        final response = await ApiService.instance.createPrompt(
          context: context,
          title: newPrompt["title"] as String,
          content: newPrompt["content"] as String,
          description: newPrompt["description"] as String,
          category: newPrompt["category"] as String,
          language: newPrompt["language"] as String,
          isPublic: newPrompt["isPublic"] as bool,
        );
  
        if (response.isNotEmpty) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Prompt created successfully!')),
          );
          widget.refresh();
          navigator.pop();
        }
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error creating prompt: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = Provider.of<CategoryState>(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "New Prompt",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
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
                          style: TextStyle(fontSize: 10),
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
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name *",
                    hintText: "Name of the prompt",
                    border:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name is required.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Prompt Language *",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
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
                  dropdownColor: Colors.white,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: categoryState.selectedCategory.isEmpty
                      ? categoryState.categories.first['value'] as String
                      : categoryState.selectedCategory,
                  onChanged: (value) {
                    categoryState.selectCategory(value!);
                  },
                  decoration: InputDecoration(
                    labelText: "Category *",
                    border:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      ),
                  ),
                  items: categoryState.categories
                      .map<DropdownMenuItem<String>>(
                          (category) => DropdownMenuItem<String>(
                                value: category['value'] as String,
                                child: Text(category['text'] as String),
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
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Describe your prompt so others can have a better understanding",
                    border:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: promptController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Prompt *",
                    hintText: "e.g. Write an article about [TOPIC]",
                    border:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      ),
                    helperText: "Use square brackets [ ] to specify user input.",
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


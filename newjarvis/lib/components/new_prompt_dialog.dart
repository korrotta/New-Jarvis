import 'package:flutter/material.dart';

class NewPromptDialog extends StatefulWidget {
  @override
  _NewPromptDialogState createState() => _NewPromptDialogState();
}

class _NewPromptDialogState extends State<NewPromptDialog> {
  bool isPrivatePrompt = true; // Radio button state
  final TextEditingController nameController = TextEditingController();
  final TextEditingController promptController = TextEditingController();

  void onSubmit() {
    // Mock data submission logic
    print("Prompt Type: ${isPrivatePrompt ? 'Private' : 'Public'}");
    print("Name: ${nameController.text}");
    print("Prompt: ${promptController.text}");
    Navigator.of(context).pop(); // Close dialog
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 600, // Adjust width as needed
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Prompt",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
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
                    title: Text("Private Prompt",
                        style: TextStyle(fontSize: 15, color: Colors.blue)),
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
                    title: Text("Public Prompt",
                        style: TextStyle(fontSize: 15, color: Colors.blue)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                hintText: "Name of the prompt",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: promptController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Prompt",
                hintText: "e.g. Write an article about [TOPIC]",
                border: OutlineInputBorder(),
                helperText: "Use square brackets [ ] to specify user input.",
                helperStyle: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel"),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Create"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

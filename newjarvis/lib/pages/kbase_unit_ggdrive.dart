import 'package:flutter/material.dart';

class CreateUnitDialogFromGoogleDrive extends StatefulWidget {
  final Function(String name) onConfirm;

  const CreateUnitDialogFromGoogleDrive({required this.onConfirm, super.key});

  @override
  State<CreateUnitDialogFromGoogleDrive> createState() =>
      _CreateUnitDialogFromGoogleDriveState();
}

class _CreateUnitDialogFromGoogleDriveState
    extends State<CreateUnitDialogFromGoogleDrive> {
  final _nameController = TextEditingController();
  bool _showNameError = false;
  String? _selectedFolder;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      if (_showNameError && _nameController.text.trim().isNotEmpty) {
        setState(() {
          _showNameError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _chooseFolder() async {
    // Simulate folder selection logic
    setState(() {
      _selectedFolder = "Sample Folder Selected";
    });
  }

  void _submit() {
    setState(() {
      _showNameError = _nameController.text.trim().isEmpty;
    });

    if (!_showNameError) {
      widget.onConfirm(_nameController.text.trim());
      Navigator.pop(context);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool showError,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: showError ? Colors.red : Colors.grey.shade400,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: showError ? Colors.red : Colors.blue,
                width: 2.0,
              ),
            ),
          ),
        ),
        if (showError)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'This field is required',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Row(
        children: [
          Image.asset(
            'assets/icons/iconDrive.png',
            width: 27,
            height: 27,
          ),
          const SizedBox(width: 8),
          const Text(
            'Google Drive',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Name:',
              showError: _showNameError,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _chooseFolder,
              icon: Image.asset(
                'assets/icons/iconDrive.png',
                width: 15,
                height: 15,
              ),
              label: Text(
                _selectedFolder ?? 'Choose Folder',
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20.0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            // Info Box
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F2FF),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: const Color(0xFF90CAF9),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ℹ You can load up to 64 pages at a time.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'If you want to increase this limitation, you need to contact me.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Email: jarvisknowledgebase@gmail.com',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Connect'),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:newjarvis/pages/google_explored.dart';

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
  String? _selectedFileName;

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

  Future<void> _openDriveExplorer() async {
    final selectedFile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GoogleDriveExplorer(),
      ),
    );

    if (selectedFile != null) {
      setState(() {
        _selectedFileName = selectedFile;
      });
    }
  }

  void _submit() {
    setState(() {
      _showNameError = _nameController.text.trim().isEmpty;
    });

    if (!_showNameError && _selectedFileName != null) {
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
              onPressed: _openDriveExplorer,
              icon: Image.asset(
                'assets/icons/iconDrive.png',
                width: 15,
                height: 15,
              ),
              label: Text(
                _selectedFileName ?? 'Choose File from Drive',
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedFileName != null ? _submit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedFileName != null ? Colors.blue : Colors.grey,
            foregroundColor: Colors.white,
          ),
          child: const Text('Connect'),
        ),
      ],
    );
  }
}

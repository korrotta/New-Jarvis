import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateUnitDialogFromWeb extends StatefulWidget {
  final Future<void> Function(String, String) onConfirm;

  const CreateUnitDialogFromWeb({required this.onConfirm, super.key});

  @override
  State<CreateUnitDialogFromWeb> createState() => _CreateUnitDialogFromWebState();
}

class _CreateUnitDialogFromWebState extends State<CreateUnitDialogFromWeb> {
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();

  bool _showNameError = false;
  bool _showUrlError = false;
  bool isLoading = false; // Trạng thái loading cho nút "Connect"

  @override
  void initState() {
    super.initState();
    _addListeners();
  }

  void _addListeners() {
    _nameController.addListener(() {
      if (_showNameError && _nameController.text.trim().isNotEmpty) {
        setState(() {
          _showNameError = false;
        });
      }
    });

    _urlController.addListener(() {
      if (_showUrlError && _urlController.text.trim().isNotEmpty) {
        setState(() {
          _showUrlError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _showNameError = _nameController.text.trim().isEmpty;
      _showUrlError = _urlController.text.trim().isEmpty;
    });

    if (!_showNameError && !_showUrlError) {
      setState(() {
        isLoading = true; // Bật trạng thái loading
      });

      try {
        await widget.onConfirm(
          _nameController.text.trim(),
          _urlController.text.trim(),
        );
      } catch (e) {
        print("Error: $e");
      } finally {
        setState(() {
          isLoading = false; // Tắt trạng thái loading
        });
      }
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
          onChanged: (_) {
            if (showError) {
              setState(() {});
            }
          },
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
      contentPadding: const EdgeInsets.all(20.0),
      title: const Row(
        children: [
          Icon(
            Icons.language,
            color: Colors.blue,
            size: 30.0,
          ),
          SizedBox(width: 10.0),
          Text(
            'Website',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Name:',
              showError: _showNameError,
            ),
            const SizedBox(height: 15.0),
            _buildTextField(
              controller: _urlController,
              label: 'Web URL:',
              showError: _showUrlError,
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null // Vô hiệu hóa nút khi đang xử lý
                    : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Connect',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 15.0),
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
    );
  }
}

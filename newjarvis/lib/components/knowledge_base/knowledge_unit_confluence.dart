import 'package:flutter/material.dart';

class CreateUnitDialogFromConfluence extends StatefulWidget {
  final Function(String, String, String, String) onConfirm;

  const CreateUnitDialogFromConfluence({required this.onConfirm, super.key});

  @override
  State<CreateUnitDialogFromConfluence> createState() =>
      _CreateUnitDialogFromConfluenceState();
}

class _CreateUnitDialogFromConfluenceState
    extends State<CreateUnitDialogFromConfluence> {
  final _nameController = TextEditingController();
  final _wikiPageController = TextEditingController();
  final _usernameController = TextEditingController();
  final _accessTokenController = TextEditingController();

  bool _showNameError = false;
  bool _showWikiPageError = false;
  bool _showUsernameError = false;
  bool _showAccessTokenError = false;
  bool _isLoading = false; // Trạng thái loading cho nút "Connect"

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

    _wikiPageController.addListener(() {
      if (_showWikiPageError && _wikiPageController.text.trim().isNotEmpty) {
        setState(() {
          _showWikiPageError = false;
        });
      }
    });

    _usernameController.addListener(() {
      if (_showUsernameError && _usernameController.text.trim().isNotEmpty) {
        setState(() {
          _showUsernameError = false;
        });
      }
    });

    _accessTokenController.addListener(() {
      if (_showAccessTokenError &&
          _accessTokenController.text.trim().isNotEmpty) {
        setState(() {
          _showAccessTokenError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _wikiPageController.dispose();
    _usernameController.dispose();
    _accessTokenController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _showNameError = _nameController.text.trim().isEmpty;
      _showWikiPageError = _wikiPageController.text.trim().isEmpty;
      _showUsernameError = _usernameController.text.trim().isEmpty;
      _showAccessTokenError = _accessTokenController.text.trim().isEmpty;
    });

    if (!_showNameError &&
        !_showWikiPageError &&
        !_showUsernameError &&
        !_showAccessTokenError) {
      setState(() {
        _isLoading = true; // Bật trạng thái loading
      });

      try {
        await widget.onConfirm(
          _nameController.text.trim(),
          _wikiPageController.text.trim(),
          _usernameController.text.trim(),
          _accessTokenController.text.trim(),
        );
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false; // Tắt trạng thái loading
        });
        Navigator.pop(context); // Đóng dialog sau khi xử lý xong
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
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Row(
        children: [
          Image.asset(
            'assets/icons/iconConfluence.png',
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 10),
          const Text(
            'Confluence',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
            const SizedBox(height: 16),
            _buildTextField(
              controller: _wikiPageController,
              label: 'Wiki Page URL:',
              showError: _showWikiPageError,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _usernameController,
              label: 'Confluence Username:',
              showError: _showUsernameError,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _accessTokenController,
              label: 'Confluence Access Token:',
              showError: _showAccessTokenError,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You can retrieve up to 128 pages at a time.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'If you want to increase this limitation, you need to contact me.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Email: jarvisknowledgebase@gmail.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
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
          onPressed: _isLoading
              ? null // Vô hiệu hóa nút khi đang xử lý
              : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: _isLoading
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
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class CreateUnitDialogFromSlack extends StatefulWidget {
  final Function(String name, String workspace, String botToken) onConfirm;

  const CreateUnitDialogFromSlack({required this.onConfirm, super.key});

  @override
  State<CreateUnitDialogFromSlack> createState() =>
      _CreateSlackUnitDialogState();
}

class _CreateSlackUnitDialogState extends State<CreateUnitDialogFromSlack> {
  final _nameController = TextEditingController();
  final _workspaceController = TextEditingController();
  final _botTokenController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _showNameError = false;
  bool _showWorkspaceError = false;
  bool _showBotTokenError = false;
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

    _workspaceController.addListener(() {
      if (_showWorkspaceError &&
          _workspaceController.text.trim().isNotEmpty) {
        setState(() {
          _showWorkspaceError = false;
        });
      }
    });

    _botTokenController.addListener(() {
      if (_showBotTokenError && _botTokenController.text.trim().isNotEmpty) {
        setState(() {
          _showBotTokenError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _workspaceController.dispose();
    _botTokenController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _showNameError = _nameController.text.trim().isEmpty;
      _showWorkspaceError = _workspaceController.text.trim().isEmpty;
      _showBotTokenError = _botTokenController.text.trim().isEmpty;
    });

    if (!_showNameError && !_showWorkspaceError && !_showBotTokenError) {
      setState(() {
        _isLoading = true; // Bật trạng thái loading
      });

      try {
        await widget.onConfirm(
          _nameController.text.trim(),
          _workspaceController.text.trim(),
          _botTokenController.text.trim(),
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
        Focus(
          child: Builder(
            builder: (BuildContext context) {
              final isFocused = Focus.of(context).hasFocus;
              return Column(
                children: [
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
                          color: showError
                              ? Colors.red
                              : (isFocused ? Colors.blue : Colors.grey.shade400),
                          width: 2.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
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
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Image.asset(
            'assets/icons/iconSlack.png',
            width: 33,
            height: 33,
          ),
          const SizedBox(width: 8),
          const Text(
            'Slack',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                showError: _showNameError,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _workspaceController,
                label: 'Slack Workspace',
                showError: _showWorkspaceError,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _botTokenController,
                label: 'Slack Bot Token',
                showError: _showBotTokenError,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Column(
                  children: [
                    Text(
                      'You can view all sessions from the past 60 days.',
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'If you want to increase this limitation, you need to contact me.',
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Email: jarvisknowledgebase@gmail.com',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
            backgroundColor: Colors.blue.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                  style:
                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}

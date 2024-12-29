import 'package:flutter/material.dart';

class EditKnowledgeDialog extends StatefulWidget {
  final Function(String, String) onConfirm;
  final String kbName;
  final String kbDescription;

  const EditKnowledgeDialog({
    required this.onConfirm,
    required this.kbName,
    required this.kbDescription,
    super.key,
  });

  @override
  State<EditKnowledgeDialog> createState() => _EditKnowledgeDialogState();
}

class _EditKnowledgeDialogState extends State<EditKnowledgeDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  final _formKey = GlobalKey<FormState>();

  // Để theo dõi số ký tự trong mô tả
  int _descriptionCharCount = 0;

  @override
  void initState() {
    super.initState();

    // Khởi tạo TextEditingController với giá trị ban đầu
    _nameController = TextEditingController(text: widget.kbName);
    _descriptionController = TextEditingController(text: widget.kbDescription);

    // Cập nhật số ký tự còn lại ngay khi mở dialog
    _descriptionCharCount = _descriptionController.text.length;

    // Lắng nghe thay đổi trong TextEditingController
    _descriptionController.addListener(_updateDescriptionCharCount);
    _nameController.addListener(() {
      setState(() {}); // Cập nhật để hiển thị số ký tự còn lại
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateDescriptionCharCount() {
    setState(() {
      _descriptionCharCount = _descriptionController.text.length;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onConfirm(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), 
      ),
      title: const Text(
        'Edit Knowledge',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Trường tên Knowledge với dấu * đỏ
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  label: RichText(
                    text: const TextSpan(
                      text: 'Knowledge Name',
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                      children: [
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Colors.red, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Enter name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), 
                  ),
                  counterText:
                      '${50 - _nameController.text.length} / 50', 
                ),
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Knowledge Name là bắt buộc';
                  }
                  if (value.trim().length > 50) {
                    return 'Tối đa 50 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Trường mô tả Knowledge
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Knowledge Description',
                  hintText: 'Enter description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), 
                  ),
                  counterText:
                      '${1000 - _descriptionCharCount} / 1000', 
                ),
                maxLines: 5,
                maxLength: 1000, // Giới hạn 1000 ký tự
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (value.trim().length > 1000) {
                      return 'Mô tả không được vượt quá 1000 ký tự (hiện tại ${value.trim().length} ký tự)';
                    }
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color.fromARGB(255, 51, 68, 179), 
          ),
          child: const Text(
            'Confirm',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
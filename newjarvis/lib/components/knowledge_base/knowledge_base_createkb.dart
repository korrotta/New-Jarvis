import 'package:flutter/material.dart';

class CreateKnowledgeDialog extends StatefulWidget {
  final Function(String, String) onConfirm;

  const CreateKnowledgeDialog({required this.onConfirm, super.key});

  @override
  State<CreateKnowledgeDialog> createState() => _CreateKnowledgeDialogState();
}

class _CreateKnowledgeDialogState extends State<CreateKnowledgeDialog> {

  final _nameController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  int _descriptionCharCount = 0;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_updateDescriptionCharCount);
    _nameController.addListener(() {
      setState(() {}); 
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
        'Create New Knowledge',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             
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
                maxLength: 1000, 
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
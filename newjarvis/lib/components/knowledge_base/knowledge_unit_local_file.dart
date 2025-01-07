// Local Files

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CreateUnitDialogFromLocalFile extends StatefulWidget {
  final Function(String) onConfirm;

  const CreateUnitDialogFromLocalFile({super.key, required this.onConfirm});

  @override
  State<CreateUnitDialogFromLocalFile> createState() =>
      _CreateUnitDialogFromLocalFileState();
}

class _CreateUnitDialogFromLocalFileState
    extends State<CreateUnitDialogFromLocalFile> {
  String? _selectedFileName;
  String? _fileName;
  bool _showFileError = false;
  bool _isLoading = false; // Trạng thái loading cho nút "Connect"

  void _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'c', 'cpp', 'docx', 'html', 'java', 'json', 'md', 'pdf', 
          'php', 'pptx', 'py', 'rb', 'tex', 'txt'
        ], // Các extension được phép upload
      );

      if (result != null && result.files.isNotEmpty) {
        final filePath = result.files.single.path;
        if (filePath != null) {
          // Lưu tên file để hiển thị
          final fileName = filePath.split('/').last;
          setState(() {
            _selectedFileName = filePath;
            _fileName = fileName;
            _showFileError = false;
          });
        }
      } else {
        // Người dùng đã hủy chọn file
        setState(() {
          _selectedFileName = null;
          _fileName = null;
          _showFileError = true;
        });
      }
    } catch (e) {
      print('Error picking file: $e');
      setState(() {
        _showFileError = true;
      });
    }
  }

  void _submit() async {
    setState(() {
      _showFileError = _selectedFileName == null || _selectedFileName!.isEmpty;
    });

    if (!_showFileError) {
      setState(() {
        _isLoading = true; // Bật trạng thái loading
      });

      try {
        await widget.onConfirm(_selectedFileName!);
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false; // Tắt trạng thái loading
        });
        Navigator.pop(context); // Đóng dialog khi xử lý xong
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      contentPadding: const EdgeInsets.all(20.0),
      title: const Row(
        children: [
          Icon(
            Icons.insert_drive_file,
            color: Colors.blue,
            size: 30.0,
          ),
          SizedBox(width: 8.0),
          Text(
            'Local file',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tiêu đề "Upload local file" có dấu *
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: const TextSpan(
                  text: 'Upload local file:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Khu vực click hoặc drag file
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: _showFileError ? Colors.red : Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.move_to_inbox,
                      color: Colors.blue.shade600,
                      size: 40.0,
                    ),
                    const SizedBox(height: 15),
                    if (_fileName != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.insert_drive_file, // Icon file
                            color: Colors.orange,
                            size: 20.0,
                          ),
                          const SizedBox(width: 8.0),
                          Flexible(
                            child: Text(
                              _fileName!,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        'Click or drag file to this area to upload',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 8),
                    const Text(
                      'Support for a single or bulk upload.\n'
                      'Strictly prohibit from uploading\n'
                      'company data or other band files',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Nếu chưa chọn file mà bấm Connect => báo lỗi
            if (_showFileError)
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'This field is required',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),

      // 2 nút Cancel & Connect ở đây
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

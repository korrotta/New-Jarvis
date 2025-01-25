// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:newjarvis/services/gg_drive_service.dart';

class GoogleDriveExplorer extends StatefulWidget {
  const GoogleDriveExplorer({super.key});

  @override
  State<GoogleDriveExplorer> createState() => _GoogleDriveExplorerState();
}

class _GoogleDriveExplorerState extends State<GoogleDriveExplorer> {
  final GoogleDriveService2 _driveService = GoogleDriveService2();
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _signInAndLoadFiles();
  }

  Future<void> _signInAndLoadFiles() async {
    try {
      final account = await _driveService.signIn();
      if (account != null) {
        await _loadDriveFiles();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign-in failed.")),
        );
        Navigator.pop(context);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during sign-in: $error")),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _loadDriveFiles([String? folderId]) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final files = await _driveService.fetchFiles(folderId: folderId);
      setState(() {
        _items = files;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading files: $error")),
      );
    }
  }

  void _onItemTap(Map<String, dynamic> item) {
    if (item['mimeType'] == 'application/vnd.google-apps.folder') {
      _loadDriveFiles(item['id']);
    } else {
      Navigator.pop(context, item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Drive Explorer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  leading: Icon(
                    item['mimeType'] == 'application/vnd.google-apps.folder'
                        ? Icons.folder
                        : Icons.insert_drive_file,
                  ),
                  title: Text(item['name'] ?? 'Unknown'),
                  onTap: () => _onItemTap(item),
                );
              },
            ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:newjarvis/services/google_drive_service.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class GoogleDriveExplorer extends StatefulWidget {
  const GoogleDriveExplorer({super.key});

  @override
  State<GoogleDriveExplorer> createState() => _GoogleDriveExplorerState();
}

class _GoogleDriveExplorerState extends State<GoogleDriveExplorer> {
  final GoogleDriveService _driveService = GoogleDriveService();
  List<drive.File> _items = [];
  String? _currentFolderId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFolderContents();
  }

  Future<void> _loadFolderContents([String? folderId]) async {
    setState(() {
      _isLoading = true;
    });

    final api = await _driveService.getDriveApi();
    if (api != null) {
      try {
        print('Loading folder contents for: $folderId');
        final items = folderId == null
            ? await _driveService.listSharedItems(api)
            : await _driveService.listItemsInFolder(api, folderId: folderId);

        setState(() {
          _currentFolderId = folderId;
          _items = items;
        });
      } catch (error) {
        print('Error loading items: $error');
        setState(() {
          _items = [];
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTap(drive.File item) {
    if (item.mimeType == 'application/vnd.google-apps.folder') {
      _loadFolderContents(item.id!);
    } else {
      Navigator.pop(context, item.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Drive Explorer'),
        leading: _currentFolderId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _loadFolderContents(),
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('No items found in this folder.'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ListTile(
                      leading: Icon(
                        item.mimeType == 'application/vnd.google-apps.folder'
                            ? Icons.folder
                            : Icons.insert_drive_file,
                      ),
                      title: Text(item.name ?? 'Unknown'),
                      onTap: () => _onItemTap(item),
                    );
                  },
                ),
    );
  }
}*/

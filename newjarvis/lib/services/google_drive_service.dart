import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';

class GoogleDriveService {
  late AutoRefreshingAuthClient _client;

  Future<drive.DriveApi?> getDriveApi() async {
    try {
      final jsonKey = await rootBundle.loadString('assets/newjarvis-446310-3f2e4f8d05cf.json');
      final credentials = ServiceAccountCredentials.fromJson(jsonKey);
      final scopes = [drive.DriveApi.driveReadonlyScope];
      _client = await clientViaServiceAccount(credentials, scopes);
      return drive.DriveApi(_client);
    } catch (error) {
      print("Error during Google Drive authentication: $error");
      return null;
    }
  }

  Future<List<drive.File>> listItemsInFolder(drive.DriveApi api, {String? folderId}) async {
    try {
      final query = folderId == null
          ? "'root' in parents and mimeType='application/vnd.google-apps.folder' and trashed=false"
          : "'$folderId' in parents and trashed=false";
      final files = await api.files.list(
        q: query,
        spaces: 'drive',
        $fields: "files(id, name, mimeType)",
      );
      print('Fetched items: ${files.files?.map((f) => f.name).toList()}');
      return files.files ?? [];
    } catch (error) {
      print("Error listing items: $error");
      return [];
    }
  }

  Future<List<drive.File>> listSharedItems(drive.DriveApi api) async {
    try {
      final files = await api.files.list(
        q: "sharedWithMe and trashed=false",
        spaces: 'drive',
        $fields: "files(id, name, mimeType, owners)",
      );
      print('Shared items: ${files.files?.map((f) => f.name).toList()}');
      return files.files ?? [];
    } catch (error) {
      print("Error listing shared items: $error");
      return [];
    }
  }

  void closeClient() {
    try {
      _client.close();
    } catch (error) {
      print("Error closing the client: $error");
    }
  }
}

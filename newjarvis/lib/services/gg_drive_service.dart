import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleDriveService2 {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
  serverClientId: '260143399375-n5l1pajas98jsuqiptjb5eh8nqre378j.apps.googleusercontent.com', // Sử dụng serverClientId từ OAuth JSON
  scopes: [
    'https://www.googleapis.com/auth/drive.readonly',
    'https://www.googleapis.com/auth/drive.metadata.readonly',
  ],
);


  Future<GoogleSignInAccount?> signIn() async {
  try {
    final account = await _googleSignIn.signIn();
    debugPrint("Signed in successfully: ${account?.email}");
    return account;
  } catch (error) {
    debugPrint("Error signing in: $error");
    return null;
  }
}


  Future<List<Map<String, dynamic>>> fetchFiles({
    String? folderId,
    String mimeType = "application/vnd.google-apps.folder",
  }) async {
    try {
      final account = _googleSignIn.currentUser;
      if (account == null) throw Exception("Not signed in");

      final authHeaders = await account.authHeaders;
      final response = await http.get(
        Uri.parse(
          'https://www.googleapis.com/drive/v3/files?q=\'${folderId ?? "root"}\' in parents and trashed=false&fields=files(id,name,mimeType)',
        ),
        headers: authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final files = data['files'] as List<dynamic>;
        return files
            .map((file) => {
                  'id': file['id'],
                  'name': file['name'],
                  'mimeType': file.containsKey('mimeType') ? file['mimeType'] : null,
                })
            .toList();
      } else {
        throw Exception("Failed to fetch files: ${response.body}");
      }
    } catch (error) {
      debugPrint("Error fetching files: $error");
      return [];
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      debugPrint("Error signing out: $error");
    }
  }
}

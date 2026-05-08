import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.username,
    required this.nama,
    required this.nim,
  });

  final int id;
  final String username;
  final String nama;
  final String nim;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: int.tryParse('${json['id']}') ?? 0,
      username: '${json['username'] ?? ''}',
      nama: '${json['nama'] ?? ''}',
      nim: '${json['nim'] ?? ''}',
    );
  }
}

class AuthService {
  AuthService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client();

  static const String _androidBaseUrl = 'http://10.0.2.2/todolist_api';
  // For web in local development use the Laragon backend at port 80.
  static const String _webFixedBaseUrl = 'http://localhost/todolist_api';

  final http.Client _client;
  String get baseUrl => kIsWeb ? _webFixedBaseUrl : _androidBaseUrl;

  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/login.php');

    final response = await _client.post(
      uri,
      body: {'username': username, 'password': password},
    );

    // Debug: print response for troubleshooting
    if (kDebugMode) {
      print('login response status: ${response.statusCode}');
      print('login response body: ${response.body}');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = null;
    }

    if (decoded is! Map<String, dynamic>) {
      // More informative error message
      final bodyPreview = response.body.length > 100
          ? '${response.body.substring(0, 100)}...'
          : response.body;
      throw AuthException(
        'Respons server tidak valid (status: ${response.statusCode}). Body: $bodyPreview',
      );
    }

    final success = decoded['success'] == true;
    final message = '${decoded['message'] ?? 'Login gagal.'}';

    if (!success) {
      throw AuthException(message);
    }

    if (response.statusCode != 200) {
      throw AuthException('Server merespons ${response.statusCode}.');
    }

    final user = decoded['user'];
    if (user is! Map<String, dynamic>) {
      throw AuthException('Data pengguna tidak ditemukan.');
    }

    return AuthUser.fromJson(user);
  }

  /// Change the password for the currently logged-in user.
  /// Username is retrieved from session on the server side.
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    String? username, // Optional fallback if session is not available
  }) async {
    final uri = Uri.parse('$baseUrl/change_password.php');

    final body = {'old_password': oldPassword, 'new_password': newPassword};

    // Add username as fallback for session
    if (username != null && username.isNotEmpty) {
      body['username'] = username;
    }

    final response = await _client.post(uri, body: body);

    // Debug: print response for troubleshooting
    if (kDebugMode) {
      print('changePassword response status: ${response.statusCode}');
      print('changePassword response body: ${response.body}');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = null;
    }

    if (decoded is! Map<String, dynamic>) {
      // More informative error message
      final bodyPreview = response.body.length > 100
          ? '${response.body.substring(0, 100)}...'
          : response.body;
      throw AuthException(
        'Respons server tidak valid (status: ${response.statusCode}). Body: $bodyPreview',
      );
    }

    final success = decoded['success'] == true;
    final message = '${decoded['message'] ?? 'Gagal mengubah password.'}';

    if (!success) {
      throw AuthException(message);
    }
  }

  void dispose() {
    _client.close();
  }
}

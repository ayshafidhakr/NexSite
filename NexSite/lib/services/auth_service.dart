// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nexsite/secure_storage.dart';

import 'package:nexsite/services/auth_service.dart'; // <-- file should be at lib/services/secure_storage.dart

/// Change this to your machine's LAN IP if testing on a real device.
/// Android emulator host mapping: use http://10.0.2.2:8000
class AuthService {
  static const String baseUrl = 'http://192.168.1.2:8000';

  /// Result model returned to the UI
  static Future<LoginResult> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/accounts/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;

        final access = data['access'] as String?;
        final refresh = data['refresh'] as String?;
        final clientType = data['client_type'] as String?;
        final message = data['message']?.toString() ?? 'Login successful';

        // Save tokens securely
        if (access != null) await SecureStorage.saveToken('access', access);
        if (refresh != null) await SecureStorage.saveToken('refresh', refresh);

        return LoginResult(
          success: true,
          token: access,
          clientType: clientType,
          message: message,
        );
      }

      // Non-200 → parse error if possible
      String msg = 'Login failed';
      try {
        final err = jsonDecode(res.body) as Map<String, dynamic>;
        msg = (err['detail'] ?? err['message'] ?? msg).toString();
      } catch (_) {}
      return LoginResult(success: false, message: msg);
    } catch (e) {
      return LoginResult(success: false, message: 'Error connecting to server: $e');
    }
  }

  /// Get headers with a valid Bearer token.
  /// If the access token is missing/expired, it tries to refresh it.
  static Future<Map<String, String>> authHeaders() async {
    String? access = await SecureStorage.readToken('access');

    if (access == null || access.isEmpty) {
      access = await _refreshAccessToken();
      if (access == null) {
        throw Exception('Not authenticated');
      }
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access',
    };
  }

  /// Refresh the access token using the stored refresh token.
  static Future<String?> _refreshAccessToken() async {
    final refresh = await SecureStorage.readToken('refresh');
    if (refresh == null || refresh.isEmpty) return null;

    final res = await http.post(
      Uri.parse('$baseUrl/api/accounts/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refresh}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final newAccess = data['access'] as String?;
      if (newAccess != null) {
        await SecureStorage.saveToken('access', newAccess);
      }
      return newAccess;
    }

    // Refresh failed → clear tokens
    await SecureStorage.deleteAll();
    return null;
  }

  static Future<void> logout() async {
    await SecureStorage.deleteAll();
  }
}

/// Keep this simple result object for the UI.
class LoginResult {
  final bool success;
  final String? token;      // access token
  final String? clientType; // 'single_owner' | 'small_builder' | 'turnkey'
  final String? message;

  LoginResult({
    required this.success,
    this.token,
    this.clientType,
    this.message,
  });
}

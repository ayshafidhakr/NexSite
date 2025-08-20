import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Create a single instance of FlutterSecureStorage
  static const _storage = FlutterSecureStorage();

  /// Save a token (access / refresh / any key)
  static Future<void> saveToken(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a token
  static Future<String?> readToken(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a token
  static Future<void> deleteToken(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete ALL tokens (useful for logout)
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
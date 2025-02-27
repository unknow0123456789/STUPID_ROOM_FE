import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> getData(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> removeData(String key) async {
    await _storage.delete(key: key);
  }
}
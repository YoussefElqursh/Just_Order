import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  final SharedPreferences _prefs;

  StorageService._(this._prefs);

  static Future<StorageService> init() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = StorageService._(prefs);
    }
    return _instance!;
  }

  static StorageService get instance {
    if (_instance == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _instance!;
  }

  // Wrapper methods for SharedPreferences
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);
  double? getDouble(String key) => _prefs.getDouble(key);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setStringList(String key, List<String> value) => _prefs.setStringList(key, value);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  Future<bool> remove(String key) => _prefs.remove(key);
  Future<bool> clear() => _prefs.clear();
}

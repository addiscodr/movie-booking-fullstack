import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String userIdkey = "USERKEY";
  static const String userNameKey = "USERNAMEKEY";
  static const String userEmailKey = "USEREMAILKEY";

  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Fallback getter to ensure _preferences is ready safely
  static SharedPreferences get prefs {
    if (_preferences == null) {
      throw Exception(
        "SharedPreferencesHelper not initialized. Call init() in main.dart",
      );
    }
    return _preferences!;
  }

  // ✅ FIXED: Use 'prefs' instead of '_preferences!' to catch uninitialized exceptions safely
  static Future<bool> saveUserId(String userId) async {
    return await prefs.setString(userIdkey, userId);
  }

  static Future<bool> saveUserName(String userName) async {
    return await prefs.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmail(String userEmail) async {
    return await prefs.setString(userEmailKey, userEmail);
  }

  static String? getUserId() {
    return _preferences?.getString(userIdkey); // Safe navigation fallback
  }

  static String? getUserName() {
    return _preferences?.getString(userNameKey);
  }

  static String? getUserEmail() {
    return _preferences?.getString(userEmailKey);
  }

  static Future<bool> removeUserId() async {
    return await prefs.remove(userIdkey);
  }

  static Future<bool> removeUserName() async {
    return await prefs.remove(userNameKey);
  }

  static Future<bool> removeUserEmail() async {
    return await prefs.remove(userEmailKey);
  }

  static Future<bool> clearAllData() async {
    return await prefs.clear();
  }
}

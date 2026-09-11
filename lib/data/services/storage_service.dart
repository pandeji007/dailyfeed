import 'package:hive_flutter/hive_flutter.dart';
import 'package:dailyfeed/core/constants.dart';

/// Wraps every Hive box used by the app.
class StorageService {
  const StorageService._();

  static late Box<dynamic> _bookmarks;
  static late Box<dynamic> _settings;
  static late Box<dynamic> _session;

  static Future<void> init() async {
    await Hive.initFlutter();
    _bookmarks = await Hive.openBox<dynamic>(StorageKeys.bookmarksBox);
    _settings = await Hive.openBox<dynamic>(StorageKeys.settingsBox);
    _session = await Hive.openBox<dynamic>(StorageKeys.sessionBox);
  }

  // --- Bookmarks ---
  static Box<dynamic> get bookmarks => _bookmarks;

  // --- Settings ---
  static Box<dynamic> get settings => _settings;

  // --- Session ---
  static Box<dynamic> get session => _session;

  static Future<void> saveUser(Map<String, dynamic> json) =>
      _session.put(StorageKeys.userKey, json);

  static Map<String, dynamic>? readUser() {
    final raw = _session.get(StorageKeys.userKey);
    return raw is Map ? Map<String, dynamic>.from(raw) : null;
  }

  static Future<void> clearUser() => _session.delete(StorageKeys.userKey);
}

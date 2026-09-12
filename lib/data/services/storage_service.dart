import 'package:hive_flutter/hive_flutter.dart';
import 'package:dailyfeed/core/constants.dart';

/// Wraps every Hive box used by the app.
class StorageService {
  const StorageService._();

  static late Box<dynamic> _bookmarks;
  static late Box<dynamic> _settings;

  static Future<void> init() async {
    await Hive.initFlutter();
    _bookmarks = await Hive.openBox<dynamic>(StorageKeys.bookmarksBox);
    _settings = await Hive.openBox<dynamic>(StorageKeys.settingsBox);
  }

  // --- Bookmarks ---
  static Box<dynamic> get bookmarks => _bookmarks;

  // --- Settings ---
  static Box<dynamic> get settings => _settings;
}

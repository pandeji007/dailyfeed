import 'package:dailyfeed/app_config.dart';

/// App-wide compile-time configuration.
class AppConfig {
  const AppConfig._();

  static const String newsBaseUrl = 'https://newsdata.io';

  static const String newsApiKey = ApiKey.newsApiKey;

  static const int pageSize = 10;
  static const Duration searchDebounce = Duration(milliseconds: 500);
}

/// Hive box names.
class StorageKeys {
  const StorageKeys._();

  static const String bookmarksBox = 'bookmarks';
  static const String settingsBox = 'settings';
  static const String authBox = 'auth';
  static const String themeModeKey = 'theme_mode';
  static const String isLoggedInKey = 'is_logged_in';
  static const String userEmailKey = 'user_email';
}

/// GoRouter paths.
class Routes {
  const Routes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String search = '/search';
  static const String bookmarks = '/bookmarks';
  static const String settings = '/settings';
  static const String detail = '/detail';
}

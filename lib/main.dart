import 'package:dailyfeed/core/app_theme.dart';
import 'package:dailyfeed/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: NewsReaderApp()));
}

class NewsReaderApp extends ConsumerWidget {
  const NewsReaderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'News Reader',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),

      themeMode: ThemeMode.system,

      home: const LoginScreen(),
    );
  }
}

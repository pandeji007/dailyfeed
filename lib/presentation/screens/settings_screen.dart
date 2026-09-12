import 'package:dailyfeed/core/app_theme.dart';
import 'package:dailyfeed/core/constants.dart';
import 'package:dailyfeed/presentation/providers/auth_provider.dart';
import 'package:dailyfeed/presentation/providers/bookmark_provider.dart';
import 'package:dailyfeed/presentation/providers/theme_provider.dart';
import 'package:dailyfeed/presentation/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        GoRouter.maybeOf(context)?.go(Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeProvider);
    final bookmarkCount = ref.watch(bookmarksProvider).length;
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const GradientText(
          'Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: GradientText(
              'APPEARANCE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            groupValue: mode,
            onChanged: (m) => ref.read(themeProvider.notifier).setMode(m!),
            title: const Text('System'),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: mode,
            onChanged: (m) => ref.read(themeProvider.notifier).setMode(m!),
            title: const Text('Light'),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: mode,
            onChanged: (m) => ref.read(themeProvider.notifier).setMode(m!),
            title: const Text('Dark'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: const Text('Saved articles'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$bookmarkCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: GradientText(
              'ACCOUNT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          if (authState.email != null && authState.email!.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Logged in as'),
              subtitle: Text(authState.email!),
            ),
          ListTile(
            leading: Icon(
              Icons.logout_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => _confirmLogout(context, ref),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dailyfeed/presentation/providers/auth_provider.dart';
import 'package:dailyfeed/presentation/providers/bookmark_provider.dart';
import 'package:dailyfeed/presentation/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeProvider);
    final user = ref.watch(authProvider).value;
    final bookmarkCount = ref.watch(bookmarksProvider).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: <Widget>[
          if (user != null)
            ListTile(
              leading: CircleAvatar(
                backgroundImage: user.image.isNotEmpty
                    ? NetworkImage(user.image)
                    : null,
                child: user.image.isEmpty ? const Icon(Icons.person) : null,
              ),
              title: Text(
                user.displayName.isEmpty ? user.username : user.displayName,
              ),
              subtitle: Text(user.email),
            ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'APPEARANCE',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
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
            trailing: Text('$bookmarkCount'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () => _confirmLogout(context, ref),
              icon: const Icon(Icons.logout),
              label: const Text('Log out'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log out?'),
          content: const Text(
            'Your saved articles will remain on this device.',
          ),
          actions: <Widget>[
            TextButton(
              // Use dialogContext, NOT the outer context
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              // Use dialogContext, NOT the outer context
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );

    // Bail out if the dialog was dismissed by tapping outside.
    if (confirmed != true) return;

    // Guard: the widget may have been disposed between dialog close and this line.
    if (!context.mounted) return;

    // Let the router's redirect handle the navigation — do NOT call context.go('/login').
    await ref.read(authProvider.notifier).logout();
  }
}

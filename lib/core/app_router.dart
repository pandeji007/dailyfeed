import 'package:dailyfeed/presentation/screens/bookmarks_screen.dart';
import 'package:dailyfeed/presentation/screens/detail_screen.dart';
import 'package:dailyfeed/presentation/screens/home_screen.dart';
import 'package:dailyfeed/presentation/screens/login_screen.dart';
import 'package:dailyfeed/presentation/screens/search_screen.dart';
import 'package:dailyfeed/presentation/screens/settings_screen.dart';
import 'package:dailyfeed/presentation/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dailyfeed/core/constants.dart';
import 'package:dailyfeed/domain/entities/article.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.login,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.detail,
        builder: (context, state) {
          final article = state.extra;
          if (article is! Article) return const _MissingScreen();
          return DetailScreen(article: article);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.bookmarks,
                builder: (context, state) => const BookmarksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _MissingScreen extends StatelessWidget {
  const _MissingScreen();
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: Text('Article is no longer available.')),
  );
}

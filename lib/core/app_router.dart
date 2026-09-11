import 'package:dailyfeed/presentation/screens/bookmarks_screen.dart';
import 'package:dailyfeed/presentation/screens/detail_screen.dart';
import 'package:dailyfeed/presentation/screens/home_screen.dart';
import 'package:dailyfeed/presentation/screens/login_screen.dart';
import 'package:dailyfeed/presentation/screens/search_screen.dart';
import 'package:dailyfeed/presentation/screens/settings_screen.dart';
import 'package:dailyfeed/presentation/widgets/app_shell.dart';
import 'package:dailyfeed/presentation/widgets/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dailyfeed/core/constants.dart';
import 'package:dailyfeed/domain/entities/article.dart';
import 'package:dailyfeed/presentation/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);
  ref.listen(authProvider, (_, __) => refresh.value++);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loc = state.matchedLocation;

      if (auth.isLoading) return loc == Routes.splash ? null : Routes.splash;

      final signedIn = auth.valueOrNull != null;
      if (!signedIn) return loc == Routes.login ? null : Routes.login;
      if (loc == Routes.login || loc == Routes.splash) return Routes.home;
      return null;
    },
    routes: <RouteBase>[
      GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: Routes.detail,
        builder: (_, state) {
          final article = state.extra;
          if (article is! Article) return const _MissingScreen();
          return DetailScreen(article: article);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => AppShell(shell: shell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.search,
                builder: (_, __) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.bookmarks,
                builder: (_, __) => const BookmarksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (_, __) => const SettingsScreen(),
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

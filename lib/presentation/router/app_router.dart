import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_home/presentation/providers/app_lock_provider.dart';
import 'package:secure_home/presentation/providers/bootstrap_provider.dart';
import 'package:secure_home/presentation/providers/settings_provider.dart';
import 'package:secure_home/presentation/screens/history/history_screen.dart';
import 'package:secure_home/presentation/screens/home/home_screen.dart';
import 'package:secure_home/presentation/screens/home/shell_screen.dart';
import 'package:secure_home/presentation/screens/lock/app_lock_screen.dart';
import 'package:secure_home/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:secure_home/presentation/screens/settings/about_screen.dart';
import 'package:secure_home/presentation/screens/settings/change_phone_screen.dart';
import 'package:secure_home/presentation/screens/settings/security_settings_screen.dart';
import 'package:secure_home/presentation/screens/settings/settings_screen.dart';
import 'package:secure_home/presentation/screens/splash/splash_screen.dart';

final _routerRefreshProvider = Provider<ValueNotifier<int>>((ref) {
  final notifier = ValueNotifier<int>(0);
  ref.listen(bootstrapProvider, (_, __) => notifier.value++);
  ref.listen(settingsProvider, (_, __) => notifier.value++);
  ref.listen(appLockProvider, (_, __) => notifier.value++);
  ref.onDispose(notifier.dispose);
  return notifier;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(_routerRefreshProvider);
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final boot = ref.read(bootstrapProvider);
      final loc = state.matchedLocation;
      if (boot.isLoading || !boot.hasValue) {
        return loc == '/splash' ? null : '/splash';
      }
      final onboarded = ref.read(settingsProvider).onboardingComplete;
      final locked = ref.read(appLockProvider);
      if (!onboarded) {
        return loc.startsWith('/onboarding') ? null : '/onboarding';
      }
      if (locked) {
        return loc == '/lock' ? null : '/lock';
      }
      if (loc == '/splash' || loc == '/lock' || loc.startsWith('/onboarding')) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/lock', builder: (context, state) => const AppLockScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => ShellScreen(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/history', builder: (context, state) => const HistoryScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: 'security',
                  builder: (context, state) => SecuritySettingsScreen(
                    focus: state.uri.queryParameters['focus'],
                  ),
                ),
                GoRoute(
                  path: 'phone',
                  builder: (context, state) => const ChangePhoneScreen(),
                ),
                GoRoute(
                  path: 'about',
                  builder: (context, state) => const AboutScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
});

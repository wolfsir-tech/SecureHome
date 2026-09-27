import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_home/core/theme/app_colors.dart';
import 'package:secure_home/core/theme/app_shadows.dart';
import 'package:secure_home/l10n/l10n.dart';

class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.border)),
          boxShadow: AppShadows.raisedSm(colors),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          backgroundColor: colors.surface,
          indicatorColor: colors.accentMuted,
          onDestinationSelected: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.shield_outlined),
              selectedIcon: Icon(Icons.shield_rounded, color: colors.accent),
              label: l10n.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.history_rounded),
              selectedIcon: Icon(Icons.history_rounded, color: colors.accent),
              label: l10n.navHistory,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded, color: colors.accent),
              label: l10n.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}

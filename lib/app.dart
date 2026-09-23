import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/core/theme/app_theme.dart';
import 'package:secure_home/domain/entities/app_settings.dart';
import 'package:secure_home/l10n/generated/app_localizations.dart';
import 'package:secure_home/presentation/providers/settings_provider.dart';
import 'package:secure_home/presentation/router/app_router.dart';
import 'package:secure_home/presentation/widgets/lifecycle_lock.dart';

class SecureHomeApp extends ConsumerWidget {
  const SecureHomeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsProvider);
    return LifecycleLock(
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: settings.themeMode,
        locale: settings.locale.toLocale(),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          // Mirror the layout for RTL languages such as Persian.
          return Directionality(
            textDirection: Directionality.of(context),
            child: child!,
          );
        },
        routerConfig: router,
      ),
    );
  }
}

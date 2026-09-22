import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/presentation/providers/settings_provider.dart';

final appLockProvider = NotifierProvider<AppLockNotifier, bool>(AppLockNotifier.new);

class AppLockNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void lock() {
    final settings = ref.read(settingsProvider);
    if (!settings.onboardingComplete) return;
    state = true;
  }

  void unlock() => state = false;
}

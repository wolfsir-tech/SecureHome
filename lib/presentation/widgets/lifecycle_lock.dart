import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/presentation/providers/app_lock_provider.dart';
import 'package:secure_home/presentation/providers/settings_provider.dart';

class LifecycleLock extends ConsumerStatefulWidget {
  const LifecycleLock({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<LifecycleLock> createState() => _LifecycleLockState();
}

class _LifecycleLockState extends ConsumerState<LifecycleLock> with WidgetsBindingObserver {
  DateTime? _pausedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final settings = ref.read(settingsProvider);
    if (!settings.onboardingComplete) return;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      _pausedAt = DateTime.now();
      if (settings.autoLockTimeout == Duration.zero) {
        ref.read(appLockProvider.notifier).lock();
      }
    }
    if (state == AppLifecycleState.resumed) {
      final pausedAt = _pausedAt;
      if (pausedAt == null) return;
      if (DateTime.now().difference(pausedAt) >= settings.autoLockTimeout) {
        ref.read(appLockProvider.notifier).lock();
      }
      _pausedAt = null;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

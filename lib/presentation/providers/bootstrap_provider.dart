import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/presentation/providers/history_provider.dart';
import 'package:secure_home/presentation/providers/settings_provider.dart';

final bootstrapProvider = FutureProvider<void>((ref) async {
  await ref.read(settingsProvider.notifier).hydrate();
  await ref.read(historyProvider.notifier).hydrate();
});

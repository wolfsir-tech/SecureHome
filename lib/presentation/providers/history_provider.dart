import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/domain/entities/command_history_item.dart';
import 'package:secure_home/presentation/providers/providers.dart';

final historyProvider =
    NotifierProvider<HistoryNotifier, List<CommandHistoryItem>>(HistoryNotifier.new);

class HistoryNotifier extends Notifier<List<CommandHistoryItem>> {
  @override
  List<CommandHistoryItem> build() => const [];

  Future<void> hydrate() async {
    state = await ref.read(historyServiceProvider).load();
  }

  Future<void> refresh() => hydrate();

  Future<void> clear() async {
    await ref.read(historyServiceProvider).clear();
    state = const [];
  }
}

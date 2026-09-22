import 'package:secure_home/domain/entities/command_history_item.dart';

abstract class HistoryRepository {
  Future<List<CommandHistoryItem>> loadAll();
  Future<void> add(CommandHistoryItem item);
  Future<void> clear();
}

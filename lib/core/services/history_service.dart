import 'package:secure_home/domain/entities/command_history_item.dart';
import 'package:secure_home/domain/repositories/history_repository.dart';
import 'package:uuid/uuid.dart';

class HistoryService {
  HistoryService(this._repository);

  final HistoryRepository _repository;
  final _uuid = const Uuid();

  Future<List<CommandHistoryItem>> load() => _repository.loadAll();

  Future<CommandHistoryItem> record({
    required HistoryAction action,
    required String destination,
    required HistoryStatus status,
    String? errorMessage,
  }) async {
    final item = CommandHistoryItem(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      action: action,
      destination: destination,
      status: status,
      errorMessage: errorMessage,
    );
    await _repository.add(item);
    return item;
  }

  Future<void> clear() => _repository.clear();
}

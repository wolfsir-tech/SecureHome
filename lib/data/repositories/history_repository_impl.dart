import 'package:secure_home/data/datasources/history_local_datasource.dart';
import 'package:secure_home/domain/entities/command_history_item.dart';
import 'package:secure_home/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this._datasource);

  final HistoryLocalDatasource _datasource;
  static const int _maxItems = 200;

  @override
  Future<List<CommandHistoryItem>> loadAll() => _datasource.load();

  @override
  Future<void> add(CommandHistoryItem item) async {
    final items = await _datasource.load();
    final next = [item, ...items];
    if (next.length > _maxItems) {
      next.removeRange(_maxItems, next.length);
    }
    await _datasource.save(next);
  }

  @override
  Future<void> clear() => _datasource.clear();
}

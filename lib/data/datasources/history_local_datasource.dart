import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:secure_home/data/models/command_history_model.dart';
import 'package:secure_home/domain/entities/command_history_item.dart';

class HistoryLocalDatasource {
  File? _file;

  Future<File> _resolve() async {
    if (_file != null) return _file!;
    final dir = await getApplicationDocumentsDirectory();
    _file = File('${dir.path}/command_history.json');
    return _file!;
  }

  Future<List<CommandHistoryItem>> load() async {
    try {
      final file = await _resolve();
      if (!await file.exists()) return [];
      final raw = await file.readAsString();
      if (raw.trim().isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map<String, dynamic>>()
          .map(CommandHistoryModel.fromJson)
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<CommandHistoryItem> items) async {
    final file = await _resolve();
    final encoded = jsonEncode(items.map(CommandHistoryModel.toJson).toList());
    await file.writeAsString(encoded, flush: true);
  }

  Future<void> clear() async {
    final file = await _resolve();
    if (await file.exists()) {
      await file.delete();
    }
  }
}

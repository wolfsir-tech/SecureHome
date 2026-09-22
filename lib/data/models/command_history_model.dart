import 'package:secure_home/domain/entities/command_history_item.dart';

class CommandHistoryModel {
  static CommandHistoryItem fromJson(Map<String, dynamic> json) {
    return CommandHistoryItem(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      action: HistoryAction.values.byName(json['action'] as String),
      destination: json['destination'] as String,
      status: HistoryStatus.values.byName(json['status'] as String),
      errorMessage: json['errorMessage'] as String?,
    );
  }

  static Map<String, dynamic> toJson(CommandHistoryItem item) {
    return {
      'id': item.id,
      'timestamp': item.timestamp.toIso8601String(),
      'action': item.action.name,
      'destination': item.destination,
      'status': item.status.name,
      'errorMessage': item.errorMessage,
    };
  }
}

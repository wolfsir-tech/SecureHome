enum HistoryAction { arm, disarm, test }

enum HistoryStatus { sent, failed }

class CommandHistoryItem {
  const CommandHistoryItem({
    required this.id,
    required this.timestamp,
    required this.action,
    required this.destination,
    required this.status,
    this.errorMessage,
  });

  final String id;
  final DateTime timestamp;
  final HistoryAction action;
  final String destination;
  final HistoryStatus status;
  final String? errorMessage;

  String get title {
    if (status == HistoryStatus.failed) return 'Failed to send command';
    switch (action) {
      case HistoryAction.arm:
        return 'Alarm activation command sent';
      case HistoryAction.disarm:
        return 'Alarm deactivation command sent';
      case HistoryAction.test:
        return 'Test command sent';
    }
  }
}

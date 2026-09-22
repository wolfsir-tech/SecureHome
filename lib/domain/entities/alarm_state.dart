enum AlarmStatus {
  unknown,
  secured,
  disarmed,
  activating,
  deactivating,
  sending,
  error,
}

extension AlarmStatusX on AlarmStatus {
  bool get isBusy =>
      this == AlarmStatus.activating ||
      this == AlarmStatus.deactivating ||
      this == AlarmStatus.sending;

  bool get isTerminal =>
      this == AlarmStatus.secured ||
      this == AlarmStatus.disarmed ||
      this == AlarmStatus.unknown ||
      this == AlarmStatus.error;

  String get storageValue => name;

  static AlarmStatus fromStorage(String? value) {
    return AlarmStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AlarmStatus.unknown,
    );
  }
}

enum AlarmAction { arm, disarm }

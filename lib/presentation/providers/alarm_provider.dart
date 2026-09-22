import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_home/core/errors/error_mapper.dart';
import 'package:secure_home/domain/entities/alarm_state.dart';
import 'package:secure_home/presentation/providers/history_provider.dart';
import 'package:secure_home/presentation/providers/providers.dart';
import 'package:secure_home/presentation/providers/settings_provider.dart';

class AlarmUiState {
  const AlarmUiState({
    required this.status,
    this.message,
    this.destination,
  });

  final AlarmStatus status;
  final String? message;
  final String? destination;

  AlarmUiState copyWith({
    AlarmStatus? status,
    String? message,
    String? destination,
    bool clearMessage = false,
  }) {
    return AlarmUiState(
      status: status ?? this.status,
      message: clearMessage ? null : (message ?? this.message),
      destination: destination ?? this.destination,
    );
  }
}

final alarmProvider = NotifierProvider<AlarmNotifier, AlarmUiState>(AlarmNotifier.new);

class AlarmNotifier extends Notifier<AlarmUiState> {
  @override
  AlarmUiState build() {
    final settings = ref.watch(settingsProvider);
    return AlarmUiState(
      status: settings.lastAlarmStatus,
      destination: settings.alarmPhoneE164,
    );
  }

  Future<void> arm() => _run(AlarmAction.arm);

  Future<void> disarm() => _run(AlarmAction.disarm);

  Future<void> _run(AlarmAction action) async {
    final previous = state.status;
    final settings = ref.read(settingsProvider);
    state = state.copyWith(
      status: action == AlarmAction.arm ? AlarmStatus.activating : AlarmStatus.deactivating,
      message: 'Sending command...',
      destination: settings.alarmPhoneE164,
    );
    await Future<void>.delayed(const Duration(milliseconds: 180));
    state = state.copyWith(status: AlarmStatus.sending, message: 'Sending command...');

    try {
      final repo = ref.read(alarmRepositoryProvider);
      if (action == AlarmAction.arm) {
        await repo.arm();
      } else {
        await repo.disarm();
      }
      final next = action == AlarmAction.arm ? AlarmStatus.secured : AlarmStatus.disarmed;
      final message = action == AlarmAction.arm
          ? 'Activation command sent.'
          : 'Deactivation command sent.';
      state = state.copyWith(status: next, message: message);
      await ref.read(settingsProvider.notifier).setLastAlarm(next);
      await ref.read(historyProvider.notifier).refresh();
    } catch (error) {
      state = state.copyWith(
        status: AlarmStatus.error,
        message: ErrorMapper.userMessage(error),
      );
      await ref.read(historyProvider.notifier).refresh();
      await Future<void>.delayed(const Duration(milliseconds: 1600));
      final fallback = previous == AlarmStatus.sending || previous.isBusy
          ? AlarmStatus.unknown
          : previous;
      state = state.copyWith(status: fallback, clearMessage: true);
    }
  }
}

import 'package:secure_home/core/services/alarm_command_service.dart';
import 'package:secure_home/core/services/settings_service.dart';
import 'package:secure_home/domain/entities/alarm_state.dart';
import 'package:secure_home/domain/repositories/alarm_repository.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  AlarmRepositoryImpl({
    required AlarmCommandService commands,
    required SettingsService settings,
  })  : _commands = commands,
        _settings = settings;

  final AlarmCommandService _commands;
  final SettingsService _settings;

  @override
  Future<void> arm() async {
    final current = await _settings.load();
    await _commands.arm(current);
  }

  @override
  Future<void> disarm() async {
    final current = await _settings.load();
    await _commands.disarm(current);
  }

  @override
  Future<void> persistStatus(AlarmStatus status) async {
    final current = await _settings.load();
    await _settings.save(
      current.copyWith(
        lastAlarmStatus: status,
        lastCommandAt: DateTime.now(),
      ),
    );
  }
}

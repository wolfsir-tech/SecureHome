import 'package:secure_home/domain/repositories/alarm_repository.dart';

class ArmAlarm {
  const ArmAlarm(this._repository);

  final AlarmRepository _repository;

  Future<void> call() => _repository.arm();
}

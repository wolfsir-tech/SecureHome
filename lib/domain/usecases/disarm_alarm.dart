import 'package:secure_home/domain/repositories/alarm_repository.dart';

class DisarmAlarm {
  const DisarmAlarm(this._repository);

  final AlarmRepository _repository;

  Future<void> call() => _repository.disarm();
}

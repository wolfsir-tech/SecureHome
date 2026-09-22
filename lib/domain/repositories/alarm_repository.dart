import 'package:secure_home/domain/entities/alarm_state.dart';

abstract class AlarmRepository {
  Future<void> arm();
  Future<void> disarm();
  Future<void> persistStatus(AlarmStatus status);
}

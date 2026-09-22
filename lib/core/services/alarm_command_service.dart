import 'package:secure_home/core/constants/alarm_commands.dart';
import 'package:secure_home/core/errors/app_exception.dart';
import 'package:secure_home/core/errors/error_mapper.dart';
import 'package:secure_home/core/services/history_service.dart';
import 'package:secure_home/core/services/permission_service.dart';
import 'package:secure_home/core/services/sms_service.dart';
import 'package:secure_home/core/utils/phone_utils.dart';
import 'package:secure_home/domain/entities/command_history_item.dart';
import 'package:secure_home/domain/entities/app_settings.dart';

class AlarmCommandService {
  AlarmCommandService({
    required SmsService smsService,
    required HistoryService historyService,
    required PermissionService permissionService,
  })  : _sms = smsService,
        _history = historyService,
        _permissions = permissionService;

  final SmsService _sms;
  final HistoryService _history;
  final PermissionService _permissions;

  Future<void> arm(AppSettings settings) {
    return _send(
      command: AlarmCommands.arm,
      action: HistoryAction.arm,
      settings: settings,
    );
  }

  Future<void> disarm(AppSettings settings) {
    return _send(
      command: AlarmCommands.disarm,
      action: HistoryAction.disarm,
      settings: settings,
    );
  }

  Future<void> _send({
    required String command,
    required HistoryAction action,
    required AppSettings settings,
  }) async {
    final phone = PhoneUtils.normalize(settings.alarmPhoneE164 ?? '');
    if (phone == null) {
      throw const ValidationException('The alarm phone number is invalid.');
    }

    await _permissions.ensureSms();

    try {
      await _sms.sendSms(
        to: phone,
        message: command,
        subscriptionId: settings.smsSubscriptionId,
      );
      await _history.record(
        action: action,
        destination: phone,
        status: HistoryStatus.sent,
      );
    } catch (error) {
      final mapped = ErrorMapper.map(error);
      await _history.record(
        action: action,
        destination: phone,
        status: HistoryStatus.failed,
        errorMessage: mapped.message,
      );
      throw mapped;
    }
  }
}

import 'package:flutter/services.dart';
import 'package:secure_home/core/constants/app_constants.dart';
import 'package:secure_home/core/errors/app_exception.dart';
import 'package:secure_home/core/errors/error_mapper.dart';
import 'package:secure_home/core/utils/phone_utils.dart';
import 'package:secure_home/domain/entities/sim_card_info.dart';

class SmsService {
  SmsService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel(AppConstants.androidChannel);

  final MethodChannel _channel;

  Future<void> sendSms({
    required String to,
    required String message,
    int? subscriptionId,
  }) async {
    final normalized = PhoneUtils.normalize(to);
    if (normalized == null) {
      throw const ValidationException('The alarm phone number is invalid.');
    }
    try {
      final result = await _channel.invokeMethod<dynamic>('sendSms', {
        'to': normalized,
        'message': message,
        'subscriptionId': subscriptionId,
      });
      if (result is Map) {
        final ok = result['ok'] == true;
        if (!ok) {
          throw ErrorMapper.fromPlatform(
            PlatformException(
              code: (result['code'] as String?) ?? 'sms_failed',
              message: result['message'] as String?,
            ),
          );
        }
        return;
      }
      throw const SmsException('Could not send the command.');
    } on AppException {
      rethrow;
    } on PlatformException catch (e) {
      throw ErrorMapper.fromPlatform(e);
    } on MissingPluginException {
      throw const SmsException(
        'Unable to send the command. Please check your SIM card.',
        code: 'plugin_missing',
      );
    }
  }

  Future<List<SimCardInfo>> getSimCards() async {
    try {
      final raw = await _channel.invokeMethod<dynamic>('getSimCards');
      if (raw is! List) return [];
      return raw.whereType<Map>().map((item) {
        return SimCardInfo(
          subscriptionId: (item['subscriptionId'] as num).toInt(),
          displayName: (item['displayName'] as String?) ?? '',
          carrierName: (item['carrierName'] as String?) ?? '',
          slotIndex: (item['slotIndex'] as num?)?.toInt() ?? 0,
          number: item['number'] as String?,
        );
      }).toList();
    } on PlatformException catch (e) {
      if (e.code.toLowerCase() == 'permission_denied') {
        throw const PermissionException(
          'Phone permission is needed to choose a SIM card.',
          code: 'permission_denied',
        );
      }
      return [];
    } on MissingPluginException {
      return [];
    }
  }

  Future<bool> isSmsCapable() async {
    try {
      final value = await _channel.invokeMethod<bool>('isSmsCapable');
      return value ?? false;
    } catch (_) {
      return false;
    }
  }
}

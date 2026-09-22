import 'package:flutter/services.dart';
import 'package:secure_home/core/errors/app_exception.dart';

class ErrorMapper {
  static AppException map(Object error) {
    if (error is AppException) return error;
    if (error is PlatformException) return fromPlatform(error);
    if (error is MissingPluginException) {
      return const SmsException(
        'Unable to send the command. Please check your SIM card.',
        code: 'plugin_missing',
      );
    }
    return const SmsException('Please try again.', code: 'unknown');
  }

  static AppException fromPlatform(PlatformException e) {
    final code = (e.code).toLowerCase();
    switch (code) {
      case 'permission_denied':
      case 'sms_permission_denied':
        return const PermissionException(
          'SMS permission is required to control the alarm.',
          code: 'permission_denied',
        );
      case 'no_sim':
      case 'sim_absent':
        return const SmsException(
          'Please insert a SIM card.',
          code: 'no_sim',
        );
      case 'radio_off':
      case 'radio_off_error':
        return const SmsException(
          'Unable to send the command. Please check your SIM card.',
          code: 'radio_off',
        );
      case 'no_service':
      case 'sms_unavailable':
        return const SmsException(
          'SMS service is unavailable right now.',
          code: 'no_service',
        );
      case 'invalid_number':
        return const ValidationException(
          'The alarm phone number is invalid.',
          code: 'invalid_number',
        );
      case 'generic_failure':
      case 'sms_failed':
        return const SmsException(
          'Could not send the command.',
          code: 'sms_failed',
        );
      default:
        return const SmsException(
          'Unable to send the command. Please check your SIM card.',
          code: 'unknown',
        );
    }
  }

  static String userMessage(Object error) => map(error).message;
}

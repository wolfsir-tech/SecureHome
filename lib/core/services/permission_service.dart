import 'package:permission_handler/permission_handler.dart';
import 'package:secure_home/core/errors/app_exception.dart';

class PermissionService {
  Future<bool> hasSms() async => Permission.sms.isGranted;

  Future<bool> hasPhone() async => Permission.phone.isGranted;

  Future<PermissionStatus> requestSms() => Permission.sms.request();

  Future<PermissionStatus> requestPhone() => Permission.phone.request();

  Future<void> ensureSms() async {
    var status = await Permission.sms.status;
    if (status.isGranted) return;
    status = await Permission.sms.request();
    if (status.isGranted) return;
    throw const PermissionException(
      'SMS permission is required to control the alarm.',
      code: 'permission_denied',
    );
  }

  Future<bool> requestAlarmPermissions() async {
    final sms = await Permission.sms.request();
    await Permission.phone.request();
    return sms.isGranted;
  }

  Future<bool> openSettings() => openAppSettings();
}

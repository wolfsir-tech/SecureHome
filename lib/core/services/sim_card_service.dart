import 'package:secure_home/core/services/sms_service.dart';
import 'package:secure_home/domain/entities/sim_card_info.dart';

class SimCardService {
  SimCardService(this._sms);

  final SmsService _sms;

  Future<List<SimCardInfo>> list() => _sms.getSimCards();

  Future<bool> hasSim() async {
    final cards = await list();
    return cards.isNotEmpty;
  }
}

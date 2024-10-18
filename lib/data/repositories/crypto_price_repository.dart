import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_price.dart';
import 'package:foxbit_hiring_test_template/domain/repositories/crypto_price_repository.dart';

class CryptoPriceRepository implements ICryptoPriceRepository {
  final String _eventName = 'SubscribeLevel1';
  final FoxbitWebSocket _ws;

  CryptoPriceRepository({
    required FoxbitWebSocket webSocket,
  }) : _ws = webSocket;

  @override
  Future<CryptoPrice> send({
    required int instrumentId,
  }) async {
    _ws.send(
      _eventName,
      {
        'InstrumentId': instrumentId,
      },
    );

    final Map map = await _ws.stream.firstWhere((message) {
      return message['n'].toString() == _eventName &&
          message['i'] == _ws.lastId;
    });

    return CryptoPrice.fromJson(map['o'] as Map<String, dynamic>);
  }
}

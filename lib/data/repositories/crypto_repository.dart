import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_coin.dart';
import 'package:foxbit_hiring_test_template/domain/repositories/crypto_repository.dart';

class CryptoRepository implements ICryptoRepository {
  final String _eventName = 'getInstruments';
  final FoxbitWebSocket _ws;

  CryptoRepository({
    required FoxbitWebSocket webSocket,
  }) : _ws = webSocket;

  @override
  Future<List<CryptoCoin>> send() async {
    _ws.send(_eventName, {});

    final Map map = await _ws.stream.firstWhere((message) {
      return message['n'].toString() == _eventName &&
          message['i'] == _ws.lastId;
    });

    final list = List.from(map['o'] as List? ?? []).map((item) {
      return CryptoCoin.fromJson(item as Map<String, dynamic>);
    }).toList();

    return list;
  }
}

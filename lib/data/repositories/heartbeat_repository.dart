import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';
import 'package:foxbit_hiring_test_template/domain/repositories/heartbeat_repository.dart';

class HeartbeatRepository implements IHeartbeatRepository {
  final String _eventName = 'PING';
  final FoxbitWebSocket _ws;

  HeartbeatRepository({
    required FoxbitWebSocket webSocket,
  }) : _ws = webSocket;

  @override
  Future<Map> send() async {
    _ws.send(_eventName, {});

    final Map map = await _ws.stream.firstWhere((message) {
      return message['n'].toString() == _eventName &&
          message['i'] == _ws.lastId;
    });

    return map;
  }
}

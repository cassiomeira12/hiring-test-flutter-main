import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';
import 'package:foxbit_hiring_test_template/data/repositories/heartbeat_repository.dart';
import 'package:foxbit_hiring_test_template/domain/usecases/heartbeat_usecase.dart';

import 'utils/default_test_observer.dart';

void main() {
  late FoxbitWebSocket webSocket;
  late HeartbeatUseCase useCase;
  late DefaultTestObserver observer;

  setUpAll(() {
    webSocket = FoxbitWebSocket();
    useCase = HeartbeatUseCase(
      HeartbeatRepository(
        webSocket: webSocket,
      ),
    );
    observer = DefaultTestObserver();
  });

  tearDownAll(() {
    useCase.dispose();
  });

  test('Validate correct execution', () async {
    useCase.execute(observer);
    while (!observer.ended) {
      await Future<dynamic>.delayed(const Duration(milliseconds: 10));
    }

    expect(observer.done, true);
    expect(observer.error, false);
  });

  test('Validate websocket ping message formation', () async {
    useCase.execute(observer);
    while (!observer.ended) {
      await Future<dynamic>.delayed(const Duration(milliseconds: 10));
    }

    expect(observer.done, true);
    expect(observer.error, false);
    expect(observer.data.toString(), '{m: 0, i: 0, n: PING, o: {msg: PONG}}');
  });
}

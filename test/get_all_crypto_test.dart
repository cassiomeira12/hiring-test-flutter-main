import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';
import 'package:foxbit_hiring_test_template/data/repositories/crypto_repository.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_coin.dart';
import 'package:foxbit_hiring_test_template/domain/usecases/get_all_crypto_usecase.dart';

import 'utils/default_test_observer.dart';

void main() {
  late FoxbitWebSocket webSocket;
  late GetAllCryptoUsecase useCase;
  late DefaultTestObserver observer;

  setUpAll(() {
    webSocket = FoxbitWebSocket();
    useCase = GetAllCryptoUsecase(
      CryptoRepository(webSocket: webSocket),
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

  test('Validate crypto list items', () async {
    useCase.execute(observer);
    while (!observer.ended) {
      await Future<dynamic>.delayed(const Duration(milliseconds: 10));
    }

    expect(observer.done, true);
    expect(observer.error, false);
    expect(observer.data, isNotNull);
    expect(observer.data, isA<List<CryptoCoin>>());
  });
}

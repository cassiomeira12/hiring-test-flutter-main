import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';
import 'package:foxbit_hiring_test_template/data/repositories/crypto_price_repository.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_price.dart';
import 'package:foxbit_hiring_test_template/domain/usecases/get_crypto_price_usecase.dart';

import 'utils/default_test_observer.dart';

void main() {
  late FoxbitWebSocket webSocket;
  late GetCryptoPriceUsecase useCase;
  late DefaultTestObserver observer;

  setUpAll(() {
    webSocket = FoxbitWebSocket();
    useCase = GetCryptoPriceUsecase(
      CryptoPriceRepository(webSocket: webSocket),
    );
    observer = DefaultTestObserver();
  });

  setUp(() {
    webSocket.connect();
  });

  tearDown(() {
    useCase.dispose();
  });

  test('Validate correct execution', () async {
    useCase.execute(observer, CryptoPriceParams(instrumentId: 1));
    while (!observer.ended) {
      await Future<dynamic>.delayed(const Duration(milliseconds: 10));
      useCase.dispose();
    }

    expect(observer.done, true);
    expect(observer.error, false);
  });

  test('Validate crypto price', () async {
    useCase.execute(observer, CryptoPriceParams(instrumentId: 1));
    while (!observer.ended) {
      await Future<dynamic>.delayed(const Duration(milliseconds: 10));
    }

    expect(observer.done, true);
    expect(observer.error, false);
    expect(observer.data, isNotNull);
    expect(observer.data, isA<CryptoPrice>());
  });
}

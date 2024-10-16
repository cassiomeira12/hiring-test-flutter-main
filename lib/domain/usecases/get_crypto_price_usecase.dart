import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_price.dart';
import 'package:foxbit_hiring_test_template/domain/repositories/crypto_price_repository.dart';

class GetCryptoPriceUsecase extends CompletableUseCase<CryptoPriceParams> {
  final ICryptoPriceRepository _repository;

  GetCryptoPriceUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(CryptoPriceParams? params) async {
    final StreamController controller = StreamController<CryptoPrice>();

    try {
      final CryptoPrice value = await _repository.send(
        instrumentId: params!.instrumentId,
      );

      controller.add(value);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }

    return controller.stream;
  }
}

class CryptoPriceParams {
  final int instrumentId;

  CryptoPriceParams({required this.instrumentId});
}

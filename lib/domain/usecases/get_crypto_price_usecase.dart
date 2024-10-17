import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_price.dart';
import 'package:foxbit_hiring_test_template/domain/repositories/crypto_price_repository.dart';

class GetCryptoPriceUsecase extends UseCase<CryptoPrice, CryptoPriceParams> {
  final ICryptoPriceRepository _repository;

  GetCryptoPriceUsecase(this._repository);

  @override
  Future<Stream<CryptoPrice>> buildUseCaseStream(
    CryptoPriceParams? params,
  ) async {
    final StreamController<CryptoPrice> controller = StreamController();

    try {
      final CryptoPrice value = await _repository.send(
        instrumentId: params!.instrumentId,
      );

      controller.add(value);
      debugPrint('GetCryptoPriceUsecase Success $value');
      controller.close();
    } catch (e) {
      debugPrint('GetCryptoPriceUsecase Error');
      controller.addError(e);
    }

    return controller.stream;
  }
}

class CryptoPriceParams {
  final int instrumentId;

  CryptoPriceParams({required this.instrumentId});
}

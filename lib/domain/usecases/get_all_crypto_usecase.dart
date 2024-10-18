import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_coin.dart';
import 'package:foxbit_hiring_test_template/domain/repositories/crypto_repository.dart';

class GetAllCryptoUsecase extends CompletableUseCase<void> {
  final ICryptoRepository _repository;

  GetAllCryptoUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(void ignore) async {
    final StreamController<List<CryptoCoin>> controller = StreamController();

    try {
      final List<CryptoCoin> map = await _repository.send();

      controller.add(map);
      debugPrint('GetAllCryptoUsecase Success');
      controller.close();
    } catch (e) {
      debugPrint('GetAllCryptoUsecase Error');
      controller.addError(e);
    }

    return controller.stream;
  }
}

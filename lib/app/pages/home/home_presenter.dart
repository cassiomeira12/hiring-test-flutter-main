// ignore_for_file: avoid_dynamic_calls, type_annotate_public_apis

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/app/utils/crypto_filter_enum.dart';
import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';
import 'package:foxbit_hiring_test_template/data/repositories/crypto_price_repository.dart';
import 'package:foxbit_hiring_test_template/data/repositories/crypto_repository.dart';
import 'package:foxbit_hiring_test_template/data/repositories/heartbeat_repository.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_coin.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_price.dart';
import 'package:foxbit_hiring_test_template/domain/usecases/get_all_crypto_usecase.dart';
import 'package:foxbit_hiring_test_template/domain/usecases/get_crypto_price_usecase.dart';
import 'package:foxbit_hiring_test_template/domain/usecases/heartbeat_usecase.dart';

class HomePresenter extends Presenter {
  late Function heartbeatOnComplete;
  late Function(dynamic) heartbeatOnError;

  late Function(List<CryptoCoin>) getCryptoOnNext;
  late Function getCryptoOnComplete;
  late Function getCryptoOnError;

  late Function(CryptoPrice) getCryptoPriceOnNext;
  late Function getCryptoPriceOnComplete;
  late Function getCryptoPriceOnError;

  late HeartbeatUseCase _heartbeatUseCase;
  late GetAllCryptoUsecase _getAllCryptoUsecase;
  late GetCryptoPriceUsecase _getCryptoPriceUsecase;

  HomePresenter({
    required FoxbitWebSocket webSocket,
  }) {
    _heartbeatUseCase = HeartbeatUseCase(
      HeartbeatRepository(
        webSocket: webSocket,
      ),
    );
    _getAllCryptoUsecase = GetAllCryptoUsecase(
      CryptoRepository(
        webSocket: webSocket,
      ),
    );
    _getCryptoPriceUsecase = GetCryptoPriceUsecase(
      CryptoPriceRepository(
        webSocket: webSocket,
      ),
    );
  }

  void sendHeartbeat() {
    _heartbeatUseCase.execute(_HeartBeatObserver(this));
  }

  void getAllCryptoCoins() {
    _getAllCryptoUsecase.execute(_GetAllCryptoObserver(this));
  }

  void getCryptoPrice(int instrumentId) {
    _getCryptoPriceUsecase.execute(
      _GetCryptoPriceObserver(this),
      CryptoPriceParams(instrumentId: instrumentId),
    );
  }

  @override
  void dispose() {
    _heartbeatUseCase.dispose();
    _getAllCryptoUsecase.dispose();
    _getCryptoPriceUsecase.dispose();
  }
}

class _HeartBeatObserver implements Observer<void> {
  HomePresenter presenter;

  _HeartBeatObserver(this.presenter);

  @override
  void onNext(_) {}

  @override
  void onComplete() {
    presenter.heartbeatOnComplete();
  }

  @override
  void onError(dynamic e) {
    presenter.heartbeatOnError(e);
  }
}

class _GetAllCryptoObserver implements Observer<List<CryptoCoin>> {
  final HomePresenter presenter;

  _GetAllCryptoObserver(this.presenter);

  @override
  void onNext(List<CryptoCoin>? response) {
    if (response?.isNotEmpty ?? false) {
      final List<int> acceptedIds = CryptoFilterEnum.values.map((item) {
        return item.instrumentId;
      }).toList();

      final List<CryptoCoin> filteredList = response!.where((item) {
        return acceptedIds.contains(item.instrumentId);
      }).toList();

      filteredList.sort((a, b) {
        final sortIndexA = CryptoFilterEnum.values
                .where((item) => item.instrumentId == a.instrumentId)
                .firstOrNull
                ?.sortIndex ??
            1;
        final sortIndexB = CryptoFilterEnum.values
                .where((item) => item.instrumentId == b.instrumentId)
                .firstOrNull
                ?.sortIndex ??
            1;
        return sortIndexA.compareTo(sortIndexB);
      });

      presenter.getCryptoOnNext(filteredList);
    }
  }

  @override
  void onComplete() {
    presenter.getCryptoOnComplete();
  }

  @override
  void onError(dynamic e) {
    presenter.getCryptoOnError(e);
  }
}

class _GetCryptoPriceObserver implements Observer<CryptoPrice> {
  final HomePresenter presenter;

  _GetCryptoPriceObserver(this.presenter);

  @override
  void onNext(CryptoPrice? response) {
    if (response != null) {
      presenter.getCryptoPriceOnNext(response);
    }
  }

  @override
  void onComplete() {
    presenter.getCryptoPriceOnComplete();
  }

  @override
  void onError(e) {
    presenter.getCryptoPriceOnError(e);
  }
}

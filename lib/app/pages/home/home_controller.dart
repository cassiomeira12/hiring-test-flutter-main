import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/app/pages/home/home_presenter.dart';
import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_coin.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_price.dart';

class HomeController extends Controller {
  final FoxbitWebSocket _ws;
  final HomePresenter _presenter;

  bool isLoading = true;

  Map<int, CryptoCoin> _cryptoCoinMap = {};
  final Map<int, CryptoPrice> _cryptoPriceMap = {};

  List<CryptoCoin> get cryptoCoinsList => _cryptoCoinMap.values.toList();
  CryptoPrice? cryptoPrice(int instrumentId) => _cryptoPriceMap[instrumentId];

  Timer? _cryptoPriceTimer;
  bool _errorHappened = false;

  HomeController({
    required FoxbitWebSocket ws,
  })  : _ws = ws,
        _presenter = HomePresenter(webSocket: ws) {
    ws.connect();
    _presenter.sendHeartbeat();
  }

  @override
  void initListeners() {
    _presenter.heartbeatOnComplete = _heartbeatOnComplete;
    _presenter.heartbeatOnError = _heartbeatOnError;

    _presenter.getCryptoOnNext = _getCryptoCoins;
    _presenter.getCryptoOnComplete = _getCryptoCoinsComplete;
    _presenter.getCryptoOnError = _cryptoCoinsOnError;

    _presenter.getCryptoPriceOnNext = _getCryptoPrice;
    _presenter.getCryptoPriceOnComplete = _getCryptoPriceComplete;
    _presenter.getCryptoPriceOnError = _cryptoPriceOnError;
  }

  @override
  void onDisposed() {
    _ws.disconnect();
    super.onDisposed();
  }

  void _heartbeatOnComplete() {
    _scheduleNextHeartbeat();
    if (_cryptoCoinMap.isEmpty) {
      _presenter.getAllCryptoCoins();
    }
  }

  void _heartbeatOnError(dynamic e) {
    _scheduleNextHeartbeat(seconds: 5);
    if (_cryptoCoinMap.isEmpty) {
      _showNetworkConnectionError();
    }
  }

  void _getCryptoCoins(List<CryptoCoin> list) {
    _cryptoCoinMap = list.asMap().map((_, value) {
      return MapEntry(value.instrumentId, value);
    });
  }

  void _getCryptoCoinsComplete() {
    _getLastCryptPrices(null);
    _scheduleNextCryptoPrice();
  }

  void _cryptoCoinsOnError(dynamic e) {
    _scheduleReconnectCryptoCoins();
    _showNetworkConnectionError();
  }

  void _getCryptoPrice(CryptoPrice price) {
    _cryptoPriceMap[price.instrumentId] = price;
  }

  void _getCryptoPriceComplete() {
    if (isLoading) {
      bool allCryptoPricesLoadded = true;
      for (final id in _cryptoCoinMap.keys.toList()) {
        if (_cryptoPriceMap[id] == null) {
          allCryptoPricesLoadded = false;
          break;
        }
      }
      if (allCryptoPricesLoadded) {
        isLoading = false;
      }
    }
    refreshUI();
  }

  void _cryptoPriceOnError(dynamic e) {
    if (_cryptoPriceTimer?.isActive ?? false) {
      _cryptoPriceTimer?.cancel();
      _scheduleReconnectCryptoCoins();
    }
  }

  void _showReconnectSuccessful() {
    _errorHappened = false;
    ScaffoldMessenger.of(getContext()).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        content: Text('Conexão restabelecida'),
      ),
    );
  }

  void _showNetworkConnectionError() {
    _errorHappened = true;
    ScaffoldMessenger.of(getContext()).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.redAccent,
        content: Text('Verifique sua conexão com a internet'),
      ),
    );
  }

  void _scheduleNextCryptoPrice() {
    if (_errorHappened) {
      _showReconnectSuccessful();
    }
    _cryptoPriceTimer = Timer.periodic(
      const Duration(seconds: 10),
      _getLastCryptPrices,
    );
  }

  Future<void> _getLastCryptPrices(_) async {
    for (final coin in cryptoCoinsList) {
      _presenter.getCryptoPrice(coin.instrumentId);
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void _scheduleReconnectCryptoCoins({int seconds = 5}) {
    Timer(Duration(seconds: seconds), () {
      _presenter.getAllCryptoCoins();
    });
  }

  void _scheduleNextHeartbeat({int seconds = 30}) {
    Timer(Duration(seconds: seconds), () {
      _presenter.sendHeartbeat();
    });
  }
}

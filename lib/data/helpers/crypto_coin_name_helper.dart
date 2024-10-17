// ignore_for_file: avoid_classes_with_only_static_members

import 'package:foxbit_hiring_test_template/app/utils/crypto_filter_enum.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_coin.dart';

abstract class CryptoCoinNameHelper {
  static String? getName(CryptoCoin coin) {
    try {
      final item = CryptoFilterEnum.values.firstWhere((item) {
        return item.instrumentId == coin.instrumentId;
      });
      return item.name;
    } catch (_) {
      return null;
    }
  }
}

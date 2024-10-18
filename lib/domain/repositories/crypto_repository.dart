import 'package:foxbit_hiring_test_template/domain/entities/crypto_coin.dart';

abstract class ICryptoRepository {
  Future<List<CryptoCoin>> send();
}

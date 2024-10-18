import 'package:foxbit_hiring_test_template/domain/entities/crypto_price.dart';

abstract class ICryptoPriceRepository {
  Future<CryptoPrice> send({required int instrumentId});
}

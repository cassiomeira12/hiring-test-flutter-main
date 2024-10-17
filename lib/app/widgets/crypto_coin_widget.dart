import 'package:flutter/material.dart';
import 'package:foxbit_hiring_test_template/app/widgets/text_style_widget.dart';
import 'package:foxbit_hiring_test_template/data/helpers/crypto_coin_name_helper.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_coin.dart';
import 'package:foxbit_hiring_test_template/domain/entities/crypto_price.dart';

class CryptoCoinWidget extends StatelessWidget {
  final CryptoCoin cryptoCoin;
  final CryptoPrice? cryptoPrice;

  const CryptoCoinWidget({
    super.key,
    required this.cryptoCoin,
    required this.cryptoPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                _image(),
                _cryptoName(),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _variacao(),
          ),
          Expanded(
            flex: 6,
            child: _price(),
          ),
        ],
      ),
    );
  }

  Widget _image() {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: Image.asset(
        'assets/images/${cryptoCoin.instrumentId}.png',
        width: 32,
        height: 32,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _cryptoName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          CryptoCoinNameHelper.getName(cryptoCoin) ?? cryptoCoin.symbol,
          style: AppTextStyle.bold(
            fontSize: 18,
          ),
        ),
        Text(
          cryptoCoin.coinSymbol,
          style: AppTextStyle.regular(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _variacao() {
    if (cryptoPrice == null) {
      return const SizedBox.shrink();
    }
    return Text(
      '${cryptoPrice!.variacaoPositiva ? '+' : '-'}${cryptoPrice!.rollingFormatted}',
      style: AppTextStyle.bold(
        fontSize: 16,
        color: cryptoPrice!.variacaoPositiva ? Colors.green : Colors.red,
      ),
    );
  }

  Widget _price() {
    return Text(
      cryptoPrice?.priceFormatted ?? '',
      textAlign: TextAlign.end,
      style: AppTextStyle.regular(
        fontSize: 22,
        color: Colors.black,
      ),
    );
  }
}

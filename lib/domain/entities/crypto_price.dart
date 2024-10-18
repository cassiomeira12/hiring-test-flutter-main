import 'package:foxbit_hiring_test_template/data/helpers/money_formatter_helper.dart';

class CryptoPrice {
  final int instrumentId;
  final double lastTradedPx;
  final double rolling24HrVolume;
  final double rolling24HrPxChange;

  CryptoPrice({
    required this.instrumentId,
    required this.lastTradedPx,
    required this.rolling24HrVolume,
    required this.rolling24HrPxChange,
  });

  factory CryptoPrice.fromJson(Map<String, dynamic> map) {
    return CryptoPrice(
      instrumentId: map['InstrumentId'] as int,
      lastTradedPx: double.parse(map['LastTradedPx'] as String),
      rolling24HrVolume: map['Rolling24HrVolume'] as double,
      rolling24HrPxChange: map['Rolling24HrPxChange'] as double,
    );
  }

  bool get variacaoPositiva {
    return rolling24HrPxChange > 0;
  }

  String get rollingFormatted {
    return rolling24HrPxChange.abs().toStringAsFixed(2);
  }

  String get priceFormatted {
    return MoneyFormatterHelper.format(lastTradedPx);
  }

  @override
  String toString() {
    return '$instrumentId $lastTradedPx V$rolling24HrVolume Px$rolling24HrPxChange';
  }
}

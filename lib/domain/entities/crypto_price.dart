class CryptoPrice {
  final double lastTradedPx;
  final double rolling24HrVolume;
  final double rolling24HrPxChange;

  CryptoPrice({
    required this.lastTradedPx,
    required this.rolling24HrVolume,
    required this.rolling24HrPxChange,
  });

  factory CryptoPrice.fromJson(Map<String, dynamic> map) {
    return CryptoPrice(
      lastTradedPx: double.parse(map['LastTradedPx'] as String),
      rolling24HrVolume: map['Rolling24HrVolume'] as double,
      rolling24HrPxChange: map['Rolling24HrPxChange'] as double,
    );
  }
}

class CryptoCoin {
  final int instrumentId;
  final String symbol;
  final int sortIndex;

  CryptoCoin({
    required this.instrumentId,
    required this.symbol,
    required this.sortIndex,
  });

  factory CryptoCoin.fromJson(Map<String, dynamic> map) {
    return CryptoCoin(
      instrumentId: map['InstrumentId'] as int,
      symbol: map['Symbol'] as String,
      sortIndex: map['SortIndex'] as int,
    );
  }

  String get coinSymbol {
    return symbol.split('/').first;
  }

  @override
  String toString() {
    return '$symbol $instrumentId $sortIndex';
  }
}

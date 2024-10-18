enum CryptoFilterEnum {
  bitcoin(instrumentId: 1, name: 'Bitcoin', sortIndex: 1),
  xrp(instrumentId: 10, name: 'XRP', sortIndex: 2),
  trueUSD(instrumentId: 6, name: 'TrueUSD', sortIndex: 3),
  ethereum(instrumentId: 4, name: 'Ethereum', sortIndex: 4),
  litecoin(instrumentId: 2, name: 'Litecoin', sortIndex: 5);

  const CryptoFilterEnum({
    required this.instrumentId,
    required this.name,
    required this.sortIndex,
  });

  final int instrumentId;
  final String name;
  final int sortIndex;
}

import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/app/application.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late FoxbitApp app;

  setUpAll(() {
    app = FoxbitApp();
  });

  testWidgets('test home page', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text('Cotação'), findsOneWidget);

    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('BTC'), findsOneWidget);

    expect(find.text('XRP'), findsNWidgets(2));

    expect(find.text('TrueUSD'), findsOneWidget);
    expect(find.text('TUSD'), findsOneWidget);

    expect(find.text('Ethereum'), findsOneWidget);
    expect(find.text('ETH'), findsOneWidget);

    expect(find.text('Litecoin'), findsOneWidget);
    expect(find.text('LTC'), findsOneWidget);
  });
}

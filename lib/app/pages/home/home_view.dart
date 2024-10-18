import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/app/pages/home/home_controller.dart';
import 'package:foxbit_hiring_test_template/app/widgets/crypto_coin_widget.dart';
import 'package:foxbit_hiring_test_template/app/widgets/text_style_widget.dart';
import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';

class HomePage extends CleanView {
  const HomePage({super.key, this.title = ""});

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends CleanViewState<HomePage, HomeController> {
  HomePageState() : super(HomeController(ws: FoxbitWebSocket()));

  @override
  Widget get view {
    return Scaffold(
      backgroundColor: const Color(0xfffefefe),
      key: globalKey,
      appBar: appBar,
      body: ControlledWidgetBuilder<HomeController>(
        builder: (context, controller) {
          return controller.isLoading ? loading : cryptoList;
        },
      ),
    );
  }

  AppBar get appBar {
    return AppBar(
      centerTitle: false,
      backgroundColor: const Color(0xfffefefe),
      title: Text(
        'Cotação',
        style: AppTextStyle.bold(
          fontSize: 24,
        ),
      ),
    );
  }

  Widget get loading {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get cryptoList {
    return ControlledWidgetBuilder<HomeController>(
      builder: (context, controller) {
        return ListView.builder(
          itemCount: controller.cryptoCoinsList.length,
          itemBuilder: (context, index) {
            return CryptoCoinWidget(
              cryptoCoin: controller.cryptoCoinsList[index],
              cryptoPrice: controller.cryptoPrice(
                controller.cryptoCoinsList[index].instrumentId,
              ),
            );
          },
        );
      },
    );
  }
}

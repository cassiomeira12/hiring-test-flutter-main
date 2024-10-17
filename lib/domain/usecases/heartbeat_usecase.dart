import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/domain/repositories/heartbeat_repository.dart';

class HeartbeatUseCase extends CompletableUseCase<void> {
  HeartbeatUseCase(this._repository);

  final IHeartbeatRepository _repository;

  @override
  Future<Stream<void>> buildUseCaseStream(void ignore) async {
    final StreamController<Map> controller = StreamController();

    try {
      final Map map = await _repository.send();

      controller.add(map);
      debugPrint('HeartbeatUseCase Success');
      controller.close();
    } catch (e) {
      debugPrint('HeartbeatUseCase Error');
      controller.addError(e);
    }

    return controller.stream;
  }
}

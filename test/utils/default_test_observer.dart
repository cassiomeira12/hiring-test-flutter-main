import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class DefaultTestObserver<T> implements Observer<T> {
  bool ended = false;
  bool done = false;
  bool error = false;
  T? data;
  late Exception exception;

  @override
  void onNext(T? data) {
    this.data = data;
  }

  @override
  void onComplete() {
    done = true;
    ended = true;
  }

  @override
  void onError(dynamic e) {
    exception = e as Exception;
    done = false;
    error = true;
    ended = true;
  }
}

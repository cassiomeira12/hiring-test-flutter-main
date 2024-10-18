// ignore_for_file: avoid_classes_with_only_static_members

import 'package:intl/intl.dart';

abstract class MoneyFormatterHelper {
  static String format(double value, {String locale = 'pt_BR'}) {
    return NumberFormat.currency(
      locale: locale,
      decimalDigits: 2,
      name: r'R$',
    ).format(value);
  }
}

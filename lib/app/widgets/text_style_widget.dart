import 'package:flutter/material.dart';
import 'package:foxbit_hiring_test_template/app/widgets/font_family.dart';

class AppTextStyle extends TextStyle {
  AppTextStyle.regular({
    FontFamily fontFamily = FontFamily.regular,
    Color? color,
    super.fontSize,
  }) : super(
          fontFamily: fontFamily.family,
          color: color ?? Colors.black,
          fontWeight: FontWeight.normal,
        );

  AppTextStyle.bold({
    FontFamily fontFamily = FontFamily.bold,
    Color? color,
    super.fontSize,
  }) : super(
          fontFamily: fontFamily.family,
          color: color ?? Colors.black,
          fontWeight: FontWeight.bold,
        );
}

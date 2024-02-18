// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newapp/res/app_color_scheme.dart';

class AppValues {
  AppValues._();
  static double get kAppPadding => 16.0;
  static double get kCardPadding => 10.0;

  static BorderRadius get kDefaultRadius => BorderRadius.circular(10);

  static EdgeInsetsGeometry get kDefaultPadding => EdgeInsets.all(kAppPadding);

  static SystemUiOverlayStyle get systemOverlayStyles => const SystemUiOverlayStyle(
        statusBarColor: AppColorScheme.kPrimaryColor,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      );
}

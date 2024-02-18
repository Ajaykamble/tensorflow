import 'package:flutter/material.dart';
import 'package:newapp/res/app_color_scheme.dart';
import 'package:newapp/utils/app_constant.dart';

class AppStyles {
  static final AppStyles _instance = AppStyles._();
  AppStyles._();
  factory AppStyles.init(BuildContext con) {
    return _instance;
  }

  /// used for app bar title
  static TextStyle get appBarStyle => const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColorScheme.kPrimaryColor);

  /// used for button text
  static TextStyle buttonStyle = const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, fontFamily: AppConstant.FONT_FAMILY);

  /// used to give style to hint hint of TextFormField,dropdown button
  static TextStyle hintStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColorScheme.kGrayColor.shade500);

  /// used to give style to error text of TextFormField,dropdown items
  static TextStyle errorStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColorScheme.errorTextColor);

  /// used to give style to text of TextFormField, dropdowns items
  static TextStyle bodyMedium = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColorScheme.kGrayColor.shade800);

  static TextStyle titleMedium = const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColorScheme.kPrimaryColor);
  static TextStyle titleSmall = const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColorScheme.kPrimaryColor);

  static const TextStyle caption = TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: AppColorScheme.kPrimaryColor);
  static TextStyle captionMedium = const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColorScheme.kPrimaryColor);
  static TextStyle subTitleSmall = const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColorScheme.kPrimaryColor);

  static TextStyle headlineMedium = const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColorScheme.kPrimaryColor);

  static TextStyle titleExtraSmall = const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColorScheme.kPrimaryColor);

  static TextStyle subTitleExtraSmall = const TextStyle(fontSize: 8, fontWeight: FontWeight.w400, color: AppColorScheme.kGrayColor);
}

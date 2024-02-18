import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newapp/res/app_color_scheme.dart';
import 'package:newapp/theme/text_button_theme_style.dart';
import 'package:newapp/utils/app_constant.dart';
import 'package:newapp/utils/app_styles.dart';
import 'filled_button_theme_style.dart';
import 'outlined_button_theme_style.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light(BuildContext _) => ThemeData.light(useMaterial3: false).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          // TargetPlatform.iOS: CustomTransitionBuilder(),
          // TargetPlatform.android: CustomTransitionBuilder(),
          // TargetPlatform.windows: CustomTransitionBuilder(),
        }),
        textTheme: Theme.of(_).textTheme.apply(
              fontFamily: AppConstant.FONT_FAMILY,
            ),
        primaryColor: AppColorScheme.kPrimaryColor,
        colorScheme: const ColorScheme.light(
          primary: AppColorScheme.kPrimaryColor,
          secondary: AppColorScheme.kPrimaryColor,
          error: Colors.red,
        ),
        dividerTheme: DividerThemeData(
          thickness: 1.3,
          color: AppColorScheme.kGrayColor.shade300,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          surfaceTintColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          outlineBorder: BorderSide.none,
          activeIndicatorBorder: BorderSide.none,
          isDense: true,
          fillColor: AppColorScheme.kLightBlueColor,
          filled: true,
          hintStyle: AppStyles.hintStyle,
          errorStyle: AppStyles.errorStyle,
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          color: Colors.white,
          elevation: 0,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButtonThemeStyle(
            customTextStyle: AppStyles.buttonStyle.copyWith(decoration: TextDecoration.underline, height: 1.5),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButtonThemeStyle(
            customTextStyle: AppStyles.buttonStyle,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButtonThemeStyle(
            customTextStyle: AppStyles.buttonStyle,
          ),
        ),
      );
}

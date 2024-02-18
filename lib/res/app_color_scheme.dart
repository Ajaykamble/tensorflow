import 'package:flutter/material.dart';

class AppColorScheme {
  AppColorScheme._();

  static Color get errorTextColor => const Color(0xffF16063);

  static Color get kPrimaryIconColor => Colors.white;

  static const Color kPrimaryColor = Color(0xFF201E52);
  static const Color kSecondaryColor = Color(0xFF009147); //#009147, #016937
  static const Color kLightBlueColor = Color(0x11201E52);
  static const Color kLightRedColor = Color(0xFFF2554B);
  //background: #E3F5FF;
  //static const Color kLightBlueColor = Color(0x11201E52);

  static const MaterialColor kGrayColor = MaterialColor(
    0xFF212121,
    {
      900: Color(0xFF212121),
      800: Color(0xFF424242),
      700: Color(0xFF616161),
      600: Color(0xFF757575),
      500: Color(0xFF9E9E9E),
      400: Color(0xFFBDBDBD),
      300: Color(0xFFE0E0E0),
      200: Color(0xFFEEEEEE),
      100: Color(0xFFF5F5F5),
      50: Color(0xFFFAFAFA),
    },
  );
//border-radius: 8px;
//background: linear-gradient(131deg, #3F497F 0%, #4972C0 41.98%, #F950AB 100%);
  static const LinearGradient kGradient = LinearGradient(
    colors: [
      kSecondaryColor, // Green
      kPrimaryColor, // Deep blue
      kLightBlueColor, // Light blue with opacity
    ],
    stops: [0.0, 0.7, 1.0],
    begin: FractionalOffset(-1, -1),
    end: FractionalOffset(1.2, 1.2),
  );

  static LinearGradient get kGradientMatches => const LinearGradient(
        colors: [
          kLightRedColor, // Green
          kPrimaryColor, // Deep blue
          kLightBlueColor, // Light blue with opacity
        ],
        stops: [0.0, 0.7, 1.0],
        begin: FractionalOffset(-1, -1),
        end: FractionalOffset(1.2, 1.2),
      );
}

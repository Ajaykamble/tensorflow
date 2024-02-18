import 'package:flutter/material.dart';
import 'package:newapp/res/app_color_scheme.dart';
import 'package:newapp/theme/filled_button_theme_style.dart';
import 'package:newapp/widgets/primary_filled_icon_button.dart';

class SecondaryFilledIconButton extends PrimaryFilledIconButton {
  const SecondaryFilledIconButton({
    super.key,
    required super.icon,
    required super.buttonTitle,
    super.onPressed,
    super.buttonThemeStyle = const FilledButtonThemeStyle(
      enabledButtonColor: AppColorScheme.kSecondaryColor,
      buttonPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    ),
    super.isLoading = false,
  });
}

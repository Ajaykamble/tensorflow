import 'package:flutter/material.dart';
import 'package:newapp/res/app_color_scheme.dart';

@immutable
class OutlinedButtonThemeStyle extends ButtonStyle {
  final Color? enabledButtonColor, disabledButtonColor;
  final Color? enabledTextColor, disabledTextColor;
  final Color? enabledBorderColor, disabledBorderColor;
  final EdgeInsets? buttonPadding;
  final TextStyle? customTextStyle;
  final BorderRadius? borderRadius;
  final bool hasBorder;

  const OutlinedButtonThemeStyle({
    this.enabledButtonColor,
    this.disabledButtonColor,
    this.enabledTextColor,
    this.disabledTextColor,
    this.enabledBorderColor,
    this.disabledBorderColor,
    this.buttonPadding,
    this.customTextStyle,
    this.borderRadius,
    this.hasBorder = true,
  });
  @override
  MaterialStateProperty<Color?>? get backgroundColor {
    return MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return disabledButtonColor ?? AppColorScheme.kGrayColor.shade50;
        }

        return enabledButtonColor ?? Colors.transparent;
      },
    );
  }

  @override
  MaterialStateProperty<Color?>? get foregroundColor {
    return MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return disabledTextColor ?? AppColorScheme.kGrayColor.shade600;
        }

        return enabledTextColor ?? AppColorScheme.kPrimaryColor;
      },
    );
  }

  @override
  MaterialStateProperty<EdgeInsetsGeometry?>? get padding {
    return buttonPadding == null ? const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20, vertical: 5)) : MaterialStatePropertyAll<EdgeInsets>(buttonPadding!);
  }

  @override
  MaterialStateProperty<BorderSide?>? get side {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (hasBorder) {
          if (states.contains(MaterialState.disabled)) {
            return BorderSide(color: disabledBorderColor ?? AppColorScheme.kGrayColor.shade300);
          }

          return BorderSide(color: enabledBorderColor ?? AppColorScheme.kPrimaryColor);
        } else {
          return BorderSide.none;
        }
      },
    );
  }

  @override
  MaterialStateProperty<OutlinedBorder?>? get shape {
    return MaterialStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
    ));
  }

  @override
  MaterialStateProperty<TextStyle?>? get textStyle {
    return customTextStyle == null ? null : MaterialStatePropertyAll<TextStyle?>(customTextStyle);
  }
}

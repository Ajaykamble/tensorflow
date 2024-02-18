import 'package:flutter/material.dart';
import 'package:newapp/theme/filled_button_theme_style.dart';

class PrimaryFilledIconButton extends StatefulWidget {
  /// [buttonTitle] is button text
  /// [widgetKey] is assigned to [FilledButton] so that it can used for automation
  final String buttonTitle;

  /// [buttonThemeStyle] is optional. if its not set i will access it from [FilledButtonThemeStyle] of [AppTheme.light] method
  final FilledButtonThemeStyle? buttonThemeStyle;

  /// callback for button click
  final void Function()? onPressed;

  final Widget icon;

  final bool isLoading;
  const PrimaryFilledIconButton({
    super.key,
    required this.icon,
    required this.buttonTitle,
    this.onPressed,
    this.buttonThemeStyle,
    this.isLoading = false,
  });

  @override
  State<PrimaryFilledIconButton> createState() => _PrimaryFilledIconButtonState();
}

class _PrimaryFilledIconButtonState extends State<PrimaryFilledIconButton> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: widget.isLoading
          ? const SizedBox(
              child: CircularProgressIndicator(),
            )
          : FilledButton.icon(
              onPressed: widget.onPressed,
              label: Text(widget.buttonTitle),
              icon: SizedBox(
                width: 20,
                height: 20,
                child: widget.icon,
              ),
              style: widget.buttonThemeStyle ?? const FilledButtonThemeStyle(buttonPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:newapp/theme/outlined_button_theme_style.dart';

class PrimaryOutlinedIconButton extends StatefulWidget {
  /// [buttonTitle] is button text
  /// [widgetKey] is assigned to [FilledButton] so that it can used for automation
  final String buttonTitle, widgetKey;

  /// [buttonThemeStyle] is optional. if its not set i will access it from [OutlinedButtonThemeStyle] of [AppTheme.light] method
  final OutlinedButtonThemeStyle? buttonThemeStyle;

  /// callback for button click
  final void Function()? onPressed;

  final Widget icon;

  final bool isLoading;
  const PrimaryOutlinedIconButton({
    super.key,
    required this.icon,
    required this.buttonTitle,
    required this.widgetKey,
    this.onPressed,
    this.buttonThemeStyle,
    this.isLoading = false,
  });

  @override
  State<PrimaryOutlinedIconButton> createState() => _PrimaryOutlinedIconButtonState();
}

class _PrimaryOutlinedIconButtonState extends State<PrimaryOutlinedIconButton> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: widget.isLoading
          ? const SizedBox(
              child: CircularProgressIndicator(),
            )
          : OutlinedButton.icon(
              key: Key(widget.widgetKey),
              onPressed: widget.onPressed,
              label: Text(widget.buttonTitle),
              icon: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: widget.icon,
                ),
              ),
              style: widget.buttonThemeStyle ??
                  const OutlinedButtonThemeStyle(
                    buttonPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
            ),
    );
  }
}

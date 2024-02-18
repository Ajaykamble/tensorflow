import 'package:flutter/material.dart';
import 'package:newapp/theme/text_button_theme_style.dart';

class PrimaryTextButton extends StatefulWidget {
  /// [buttonTitle] is button text
  /// [widgetKey] is assigned to [FilledButton] so that it can used for automation
  final String buttonTitle;

  /// [buttonThemeStyle] is optional. if its not set i will access it from [TextButtonThemeStyle] of [AppTheme.light] method
  final TextButtonThemeStyle? buttonThemeStyle;

  /// callback for button click
  final void Function()? onPressed;

  final bool isLoading;
  const PrimaryTextButton({
    super.key,
    required this.buttonTitle,
    this.onPressed,
    this.buttonThemeStyle,
    this.isLoading = false,
  });

  @override
  State<PrimaryTextButton> createState() => _PrimaryTextButtonState();
}

class _PrimaryTextButtonState extends State<PrimaryTextButton> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: widget.isLoading
          ? const SizedBox(
              child: CircularProgressIndicator(),
            )
          : TextButton(
              onPressed: widget.onPressed,
              style: widget.buttonThemeStyle,
              child: Text(widget.buttonTitle),
            ),
    );
  }
}

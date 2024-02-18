import 'package:flutter/material.dart';
import 'package:newapp/res/app_color_scheme.dart';
import 'package:newapp/utils/app_styles.dart';
import 'package:newapp/widgets/primary_filled_button.dart';
import 'package:newapp/widgets/primary_outlined_button.dart';
import 'package:newapp/widgets/space_widget.dart';

class CustomAlertDialog extends StatelessWidget {
  /// [title] is title text for alert dialog
  /// [subtitle] is description for alert dialog
  /// [buttonText] is button text of alert dialog
  final String title, subtitle, buttonText;

  /// keys that can used for testing
  final String titleKey, subtitleKey, buttonKey;

  /// [onOkPressed] action for button of alertDialog
  /// if [onOkPressed] is not passed then default action will close the popup.
  final VoidCallback? onOkPressed;

  final VoidCallback? onCancelPress;
  final String? buttonCancelText, buttonCancelKey;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.titleKey,
    required this.subtitleKey,
    required this.buttonKey,
    this.onOkPressed,
    this.onCancelPress,
    this.buttonCancelKey,
    this.buttonCancelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                key: Key(titleKey),
                style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColorScheme.kPrimaryColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                subtitle,
                key: Key(subtitleKey),
                style: AppStyles.subTitleSmall,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: PrimaryFilledButton(
                        buttonTitle: buttonText,
                        onPressed: onOkPressed ??
                            () {
                              Navigator.pop(context);
                            },
                      ),
                    ),
                  ),
                  if (onCancelPress != null) ...[
                    const SpaceWidget(),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: PrimaryOutlinedButton(
                          buttonTitle: buttonCancelText ?? "",
                          onPressed: onCancelPress,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

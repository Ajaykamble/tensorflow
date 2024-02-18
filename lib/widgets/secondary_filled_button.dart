import 'package:newapp/res/app_color_scheme.dart';
import 'package:newapp/theme/filled_button_theme_style.dart';
import 'package:newapp/widgets/primary_filled_button.dart';

class SecondaryFilledButton extends PrimaryFilledButton {
  const SecondaryFilledButton({
    required super.buttonTitle,
    super.key,
    super.onPressed,
    super.buttonThemeStyle = const FilledButtonThemeStyle(
      enabledButtonColor: AppColorScheme.kSecondaryColor,
    ),
    super.isLoading = false,
  });
}

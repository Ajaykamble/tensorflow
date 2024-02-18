import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:newapp/res/app_values.dart';
import 'package:newapp/utils/enums.dart';
import 'package:newapp/widgets/choose_image_widget.dart';
import 'package:newapp/widgets/custom_alert_dilog.dart';
import 'package:newapp/widgets/custom_image_viewer.dart';

class CommonFunctions<T> {
  static Future<DateTime?> chooseDate({required BuildContext context, DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
    initialDate ??= DateTime.now();
    firstDate ??= DateTime(2000);
    lastDate ??= DateTime(2050);

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
  }

  /// opens browser with privacy policy link
  static void onPrivacyPolicyClick() {
    //TODO: add url launcher implementation
  }

  /// opens browser with Terms and conditions link
  static void onTermsConditionClick() {
    //TODO: add url launcher implementation
  }

  /// opens the apps settings
  // static void openAppSettings() async {
  //   await Geolocator.openAppSettings();
  // }

  static Future<T> openDialog<T>({
    required BuildContext context,
    required String subtitle,
    required String buttonText,
    required Function(BuildContext context)? action,
    String? title,
    Function(BuildContext context)? onCancelAction,
    String? buttonCancelText,
  }) async {
    const String _ALERT = "Alert";
    const String _KEY_TITLE = "key_text_title";
    const String _KEY_SUBTITLE = "key_text_subtitle";
    const String _KEY_BUTTON = "key_button_dialog";
    const String _KEY_BUTTON_NO = "key_button_no_dialog";

    return await showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (context) => CustomAlertDialog(
        title: title ?? _ALERT,
        subtitle: subtitle,
        buttonText: buttonText,
        titleKey: _KEY_TITLE,
        subtitleKey: _KEY_SUBTITLE,
        buttonKey: _KEY_BUTTON,
        buttonCancelKey: _KEY_BUTTON_NO,
        buttonCancelText: buttonCancelText,
        onCancelPress: onCancelAction == null
            ? null
            : () {
                onCancelAction(context);
              },
        onOkPressed: action == null
            ? null
            : () {
                action(context);
              },
      ),
    );
  }

  static Future<void> showImage(BuildContext context, String url) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (context) => CustomImageViewer(url: url),
    );
  }

  ///[chooseImage] help you choose image from device
  /// it has two option
  /// you can choose either camera or choose image from gallery
  /// this function will return XFile object
  /// if you don't choose anything it will return null;
  static Future<XFile?> chooseImage({required BuildContext context}) async {
    if (context.mounted) {
      return await showModalBottomSheet(
        context: context,
        elevation: 10,
        isScrollControlled: true,
        barrierColor: Colors.black.withOpacity(0.1),
        backgroundColor: Colors.white,
        useSafeArea: true,
        shape: RoundedRectangleBorder(
          borderRadius: AppValues.kDefaultRadius,
        ),
        builder: (context) => ChooseImageWidget(
          heading: "Choose Image",
          onFileSelected: (file) {
            Navigator.pop(context,file);
          },
        ),
      );
    }

    return null;
  }

  static bool get isMobilePlatform => Platform.isAndroid || Platform.isIOS;

  static CircularAvatarType getAvatarType(String? path, Uint8List? imageBytes) {
    print("path : ${path} , imageBytes : ${imageBytes}");
    if (imageBytes != null) {
      return CircularAvatarType.MEMORY;
    }
    if (path == null) {
      return CircularAvatarType.DEFAULT;
    } else {
      return CircularAvatarType.NETWORK;
    }
  }
}

class SvgElement {
  String id, path, color, name;
  double xmlWidth, xmlHeight;
  SvgElement({required this.id, required this.path, required this.color, required this.name, required this.xmlHeight, required this.xmlWidth});
}

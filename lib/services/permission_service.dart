// ignore_for_file: constant_identifier_names

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:newapp/utils/common_fuctions.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  PermissionService._();
  static PermissionService permissionService = PermissionService._();

  /// [checkCameraPermission] method helps to check app has camera permission or not
  /// it will return status of camera permission in bool format
  /// return `true` if the user granted camera permission
  /// return `false` if the user has not granted camera permission
  Future<bool> checkCameraPermission(BuildContext context) async {
    const String ERROR_CAMERA_PERMISSION_DENIED = "We require camera permission to use this feature. Please grant camera permissions in your app settings.";
    const String GRANT_CAMERA_CTA = "Continue";
    const String _DIALOG_TITLE = "Information";

    /// checks the current status of camera permission
    PermissionStatus status = await Permission.camera.status;
    log("status: $status");
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      /// if current status is other than [PermissionStatus.granted] then we are requesting user to give permission
      /// it will show native permission dialog
      PermissionStatus requestedStatus = await Permission.camera.request();
      switch (requestedStatus) {
        case PermissionStatus.granted:
          return true;
        default:
          if (context.mounted) {
            /// after requesting permission from user. if user didn't grant camera permission
            /// then we will show dialog on screen with `Alert` as title
            /// [ERROR_CAMERA_PERMISSION_DENIED] as description and
            /// [GRANT_CAMERA_CTA] as button text
            CommonFunctions.openDialog(
              context: context,
              action: (context) {
                //CommonFunctions.openAppSettings();
                Navigator.pop(context);
              },
              subtitle: ERROR_CAMERA_PERMISSION_DENIED,
              buttonText: GRANT_CAMERA_CTA,
              title: _DIALOG_TITLE,
            );
          }
          break;
      }

      return false;
    }
  }

  Future<bool> checkMicroPhonePermission(BuildContext context) async {
    const String ERROR_CAMERA_PERMISSION_DENIED = "We require Microphone permission to use this feature. Please grant Microphone permissions in your app settings.";
    const String GRANT_CAMERA_CTA = "Continue";
    const String _DIALOG_TITLE = "Information";

    Permission microphonePermission = Permission.microphone;

    /// checks the current status of camera permission
    PermissionStatus status = await microphonePermission.status;
    log("status: $status");
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      /// if current status is other than [PermissionStatus.granted] then we are requesting user to give permission
      /// it will show native permission dialog
      PermissionStatus requestedStatus = await microphonePermission.request();
      switch (requestedStatus) {
        case PermissionStatus.granted:
          return true;
        default:
          if (context.mounted) {
            /// after requesting permission from user. if user didn't grant camera permission
            /// then we will show dialog on screen with `Alert` as title
            /// [ERROR_CAMERA_PERMISSION_DENIED] as description and
            /// [GRANT_CAMERA_CTA] as button text
            CommonFunctions.openDialog(
              context: context,
              action: (context) {
                // CommonFunctions.openAppSettings();
                Navigator.pop(context);
              },
              subtitle: ERROR_CAMERA_PERMISSION_DENIED,
              buttonText: GRANT_CAMERA_CTA,
              title: _DIALOG_TITLE,
            );
          }
          break;
      }

      return false;
    }
  }
}

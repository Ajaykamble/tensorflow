// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newapp/res/app_color_scheme.dart';
import 'package:newapp/services/permission_service.dart';
import 'package:newapp/utils/app_styles.dart';
import 'package:newapp/viewes/camera_view.dart';
import 'space_widget.dart';

class ChooseImageWidget extends StatefulWidget {
  /// [heading] is label text
  /// if you don't pass heading it wont be visible
  final String? heading;

  final void Function(XFile?) onFileSelected;

  const ChooseImageWidget({
    super.key,
    this.heading,
    required this.onFileSelected,
  });

  @override
  State<ChooseImageWidget> createState() => _CustomUploadWidgetState();
}

class _CustomUploadWidgetState extends State<ChooseImageWidget> {
  static const String TITLE_BUTTON_CAMERA = "Camera";
  static const String TITLE_BUTTON_BROWSE = "Browse";

  /// keys
  final Key KEY_TITLE_CAMERA = const Key("key_title_camera");
  final Key KEY_TITLE_BROWSE = const Key("key_title_browse");
  final Key KEY_TITLE_HEADING = const Key("key_title_heading");

  final Key KEY_BUTTON_CAMERA = const Key("key_button_camera");
  final Key KEY_BUTTON_BROWSE = const Key("key_button_browse");

  double outerPadding = 20.0;

  captureCameraImage() async{
     bool hasCameraPermission = await PermissionService.permissionService.checkCameraPermission(context);
     if (hasCameraPermission) {
       XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);
       widget.onFileSelected(file);
     }
    
  }

  Future<void> chooseImage() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    widget.onFileSelected(file);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    double spaceBetweenCard = 15;

    double cardWidth = width - (outerPadding * 2) - spaceBetweenCard;
    cardWidth = cardWidth / 2;

    cardWidth = cardWidth > 200 ? 200 : cardWidth;

    return Padding(
      padding: EdgeInsets.all(outerPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 50.0,
              height: 5.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                color: AppColorScheme.kGrayColor.shade300,
              ),
            ),
          ),
          if (widget.heading != null) ...[
            const SpaceWidget(
              height: 15,
            ),
            Text(
              widget.heading ?? "",
              key: KEY_TITLE_HEADING,
              style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
          const SpaceWidget(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox.square(
                dimension: cardWidth,
                child: SquareButton(
                  cardKey: KEY_BUTTON_CAMERA,
                  onCardClick: () {
                    captureCameraImage();
                  },
                  title: TITLE_BUTTON_CAMERA,
                  titleKey: KEY_TITLE_CAMERA,
                  svgPath: "",
                ),
              ),
              SpaceWidget(
                width: spaceBetweenCard,
              ),
              SizedBox.square(
                dimension: cardWidth,
                child: SquareButton(
                  cardKey: KEY_BUTTON_BROWSE,
                  onCardClick: () {
                    chooseImage();
                  },
                  title: TITLE_BUTTON_BROWSE,
                  titleKey: KEY_TITLE_BROWSE,
                  svgPath: "",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SquareButton extends StatelessWidget {
  final Key cardKey, titleKey;
  final VoidCallback onCardClick;
  final String title;
  final String svgPath;
  final Color iconColor;

  const SquareButton({
    super.key,
    required this.cardKey,
    required this.onCardClick,
    required this.title,
    required this.titleKey,
    required this.svgPath,
    this.iconColor = AppColorScheme.kPrimaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: cardKey,
      onTap: onCardClick,
      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          border: Border.all(color: AppColorScheme.kGrayColor.shade300, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
            ),
            const SpaceWidget(
              height: 10,
            ),
            Text(
              title,
              key: titleKey,
              style: AppStyles.titleSmall.copyWith(color: AppColorScheme.kPrimaryColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

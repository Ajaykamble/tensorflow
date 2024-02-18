import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newapp/res/app_color_scheme.dart';
import 'package:newapp/utils/enums.dart';

class CustomCircularAvatar extends StatelessWidget {
  final bool isEditable;
  final String? assetPath;
  final double diameter;
  final CircularAvatarType avatarType;
  final VoidCallback? onEditClick;
  final Color borderColor;
  final Color backgroundColor;
  final Uint8List? imageBytes;
  final BoxBorder? border;
  final bool hasBorder;

  const CustomCircularAvatar({
    super.key,
    this.assetPath,
    this.onEditClick,
    this.imageBytes,
    this.border,
    this.hasBorder = true,
    this.isEditable = false,
    this.diameter = 130,
    this.avatarType = CircularAvatarType.DEFAULT,
    this.borderColor = AppColorScheme.kPrimaryColor,
    this.backgroundColor = AppColorScheme.kLightBlueColor,
  });

  @override
  Widget build(BuildContext context) {
    BoxBorder? imageBorder = (!hasBorder) ? null : border ?? Border.all(color: borderColor, width: 2);
    return SizedBox.square(
      dimension: diameter,
      child: Stack(
        children: [
          /* Positioned.fill(
            child: Container(
              color: Colors.red,
            ),
          ), */
          if (avatarType == CircularAvatarType.MEMORY)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: imageBorder,
                  shape: BoxShape.circle,
                  color: backgroundColor,
                  image: DecorationImage(image: MemoryImage(imageBytes!), fit: BoxFit.cover),
                ),
              ),
            ),
          if (avatarType == CircularAvatarType.IMG_ASSET)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: imageBorder,
                  shape: BoxShape.circle,
                  color: backgroundColor,
                  image: DecorationImage(image: AssetImage(assetPath!), fit: BoxFit.cover),
                ),
              ),
            ),
          if (avatarType == CircularAvatarType.DEFAULT || avatarType == CircularAvatarType.SVG_ASSET)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: imageBorder,
                  shape: BoxShape.circle,
                  color: backgroundColor,
                ),
                child: Center(child: SvgPicture.asset("", fit: BoxFit.cover)),
              ),
            ),
          if (avatarType == CircularAvatarType.NETWORK)
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: assetPath ?? "",
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                  height: diameter,
                  width: diameter,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: imageBorder,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  padding: EdgeInsets.all(diameter * 0.25),
                  decoration: BoxDecoration(
                    border: imageBorder,
                    shape: BoxShape.circle,
                    color: AppColorScheme.kPrimaryColor,
                  ),
                  child: const Center(child: null),
                ),
              ),
            ),
          if (isEditable)
            Positioned(
              bottom: 0,
              right: 0,
              child: Material(
                color: AppColorScheme.kPrimaryColor,
                borderRadius: BorderRadius.circular(35),
                child: InkWell(
                  onTap: onEditClick,
                  borderRadius: BorderRadius.circular(35),
                  child: SizedBox(
                    width: diameter * 0.25,
                    height: diameter * 0.25,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

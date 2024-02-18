import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newapp/res/app_color_scheme.dart';

class CustomNetworkImage extends StatelessWidget {
  final String url;
  final String baseUrl;
  final Color backgroundColor;
  bool showGradient;
  var backgroundGradient;

  CustomNetworkImage({
    super.key,
    required this.url,
    String? imgBaseUrl,
    this.backgroundColor = AppColorScheme.kLightBlueColor,
    this.showGradient = false,
    this.backgroundGradient = AppColorScheme.kGradient,
  }) : baseUrl = imgBaseUrl ?? "";

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: showGradient ? backgroundGradient : null,
          color: showGradient ? null : backgroundColor,
        ),
        child: Center(
          child: SvgPicture.asset(
            "",
            width: 30,
            height: 30,
          ),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: "${baseUrl}${url}",
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => Container(
        decoration: BoxDecoration(
          gradient: showGradient ? backgroundGradient : null,
          color: showGradient ? null : backgroundColor,
        ),
        child: showGradient ? null : const Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}

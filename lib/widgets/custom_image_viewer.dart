import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newapp/res/app_color_scheme.dart';

class CustomImageViewer extends StatelessWidget {
  final String url;
  const CustomImageViewer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: url,
              progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                color: AppColorScheme.kLightBlueColor,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Center(
                        child: SvgPicture.asset(
                          "",
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    Positioned.fill(child: Center(child: CircularProgressIndicator(value: downloadProgress.progress))),
                  ],
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              mini: true,
              child: const Icon(
                Icons.close,
                color: Colors.white,
              )),
        )
      ],
    );
  }
}

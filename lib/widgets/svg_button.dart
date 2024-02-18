import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newapp/res/app_color_scheme.dart';

class SvgButton extends StatelessWidget {
  final double buttonSize;
  final VoidCallback onClick;
  final String path;
  final Color color;
  const SvgButton({super.key, required this.onClick, required this.path, this.buttonSize = 24, this.color = AppColorScheme.kPrimaryColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: SizedBox.square(
        dimension: buttonSize + 10,
        child: Center(
          child: SvgPicture.asset(
            path,
            width: buttonSize,
            height: buttonSize,
          ),
        ),
      ),
    );
  }
}

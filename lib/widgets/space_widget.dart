import 'package:flutter/material.dart';

class SpaceWidget extends StatelessWidget {
  final double height, width;
  const SpaceWidget({super.key, this.height = 10, this.width = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}

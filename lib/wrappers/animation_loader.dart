import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationLoader extends StatelessWidget {
  final String assetName;
  final double? width, height;
  final BoxFit boxFit;

  const AnimationLoader({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    required this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      assetName,
      width: width,
      height: height,
      fit: boxFit,
    );
  }
}

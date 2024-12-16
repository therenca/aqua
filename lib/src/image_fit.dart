import 'package:flutter/material.dart';

class Fit extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  const Fit({Key? key, required this.child, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [Positioned.fill(child: child)],
      ),
    );
  }
}

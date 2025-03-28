import 'dart:ui';
import 'package:flutter/material.dart';

class Glassmorphism extends StatelessWidget {
  final double blur;
  final double opacity;
  final Widget child;
  final double? borderRadius;
  final Border? border;
  final Alignment alignment;

  const Glassmorphism(
      {super.key,
      required this.blur,
      required this.opacity,
      required this.child,
      this.border,
      this.borderRadius,
      this.alignment = Alignment.center});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          alignment: alignment,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((opacity * 255).round()),
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? 0.0)),
            border: border ??
                Border.all(
                    width: 1.5,
                    color: Colors.white.withAlpha((0.2 * 255).round())),
          ),
          child: child,
        ),
      ),
    );
  }
}

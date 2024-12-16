import 'package:flutter/material.dart';

class CenterInColumn extends StatelessWidget {
  final int flex;
  final Widget child;

  CenterInColumn({required this.child, this.flex = 2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: flex,
          child: child,
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }
}

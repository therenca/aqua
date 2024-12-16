import 'package:flutter/material.dart';

void showSnackBar(String info, BuildContext context,
    {Color color = Colors.white,
    Color bgColor = Colors.redAccent,
    bool mounted = false,
    int seconds = 2}) {
  if (mounted) {
    var snackBar = SnackBar(
      duration: Duration(seconds: seconds),
      backgroundColor: bgColor,
      content: Text(
        info,
        style: TextStyle(
          fontSize: 13.0,
          color: color,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

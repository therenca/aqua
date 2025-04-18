import 'dart:async';
import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatefulWidget {
  final GlobalKey? key;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final dynamic beforeInput;
  final double fontSize;
  final Color textColor;
  final Color hintColor;
  final Color labelColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final double borderWidth;
  final double focusBorderWidth;
  final double errorBorderWidth;
  final double borderRadius;
  final String labelText;
  final String hintText;
  final Widget? error;
  final String? errorText;
  final TextStyle? textStyle;
  final TextAlignVertical? textAlignVertical;
  final FloatingLabelBehavior floatingLabelBehavior;

  final bool isOutlineBorder;
  final bool isObscureText;
  final bool isCollapsed;

  final int maxLines;
  final int? maxLength;
  final double cursorWidth;
  final double verticalPadding;
  final double horizontalPadding;
  final TextInputType keyboardType;

  final Function(String, TextEditingController?)? onChanged;
  final Function(String?)? validator;
  final Function(String)? onSubmitted;

  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;

  final TextAlign? textAlign;
  final TextStyle? hintTextStyle;
  final TextStyle? labelTextStyle;

  final bool isFilled;
  final Color? filledColor;

  final IconData? prefixIconData;
  final Color prefixIconColor;
  final Color focusedPrefixIconColor;
  final double prefixIconSize;

  final Color cursorColor;

  final StreamController? streamController;

  TextFormFieldCustom(
      {this.key,
      this.prefixIcon,
      this.suffixIcon,
      this.beforeInput,
      this.fontSize = 13.0,
      this.textColor = Colors.black,
      this.hintColor = Colors.black,
      this.labelColor = Colors.black,
      this.borderColor = Colors.black,
      this.focusedBorderColor = Colors.black,
      this.errorBorderColor = Colors.red,
      this.prefixIconData,
      this.prefixIconColor = Colors.black,
      this.focusedPrefixIconColor = Colors.black,
      this.prefixIconSize = 17.0,
      this.borderWidth = 2.0,
      this.focusBorderWidth = 2.0,
      this.errorBorderWidth = 1.0,
      this.borderRadius = 4.0,
      this.labelText = '',
      this.hintText = '',
      this.prefix,
      this.isOutlineBorder = false,
      this.isObscureText = false,
      this.isCollapsed = false,
      this.textAlignVertical,
      this.maxLines = 1,
      this.maxLength,
      this.cursorWidth = 2.0,
      this.verticalPadding = 0.0,
      this.horizontalPadding = 0.0,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.onSubmitted,
      this.onChanged,
      this.focusNode,
      this.textInputAction,
      this.controller,
      this.hintTextStyle,
      this.labelTextStyle,
      this.isFilled = false,
      this.filledColor,
      this.cursorColor = Colors.red,
      this.streamController,
      this.textAlign,
      this.textStyle,
      this.error,
      this.errorText,
      this.floatingLabelBehavior = FloatingLabelBehavior.auto});

  @override
  _TextFormFieldCustomState createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();

    if (widget.focusNode != null) {
      widget.focusNode!.addListener(() {
        hasFocus = widget.focusNode!.hasFocus;
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    // throws the following error
    // A TextEditingController was used after being disposed.
    // widget.controller?.dispose();

    // you must dispose your own controller
    super.dispose();
  }

  Widget _buildTextFormField(BuildContext context) {
    BorderSide borderSide =
        BorderSide(width: widget.borderWidth, color: widget.borderColor);

    BorderSide focusedBorderSide = BorderSide(
        width: widget.focusBorderWidth, color: widget.focusedBorderColor);
    BorderSide errorBorderSide = BorderSide(
        width: widget.errorBorderWidth, color: widget.errorBorderColor);

    Widget? _buildPrefixIcon() {
      Widget? _prefixIcon;

      if (widget.prefixIconData != null) {
        _prefixIcon = Icon(widget.prefixIconData,
            size: widget.prefixIconSize,
            color: hasFocus
                ? widget.focusedPrefixIconColor
                : widget.prefixIconColor);
      } else {}

      return _prefixIcon;
    }

    return TextFormField(
      key: widget.key,
      style: widget.textStyle ??
          TextStyle(fontSize: widget.fontSize, color: widget.textColor),
      textAlignVertical: widget.textAlignVertical,
      keyboardType: widget.keyboardType,
      obscureText: widget.isObscureText,
      validator: (inputValue) => widget.validator?.call(inputValue),
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: (inputValue) => widget.onSubmitted?.call(inputValue),
      decoration: InputDecoration(
          isCollapsed: widget.isCollapsed,
          icon: widget.beforeInput,
          floatingLabelBehavior: widget.floatingLabelBehavior,
          enabledBorder: widget.isOutlineBorder
              ? OutlineInputBorder(
                  borderSide: borderSide,
                  borderRadius: BorderRadius.circular(widget.borderRadius))
              : UnderlineInputBorder(
                  borderSide: borderSide,
                ),
          focusedBorder: widget.isOutlineBorder
              ? OutlineInputBorder(
                  borderSide: focusedBorderSide,
                  borderRadius: BorderRadius.circular(widget.borderRadius))
              : UnderlineInputBorder(borderSide: focusedBorderSide),
          contentPadding: EdgeInsets.symmetric(
              vertical: widget.verticalPadding,
              horizontal: widget.horizontalPadding),
          labelText: widget.labelText,
          labelStyle: widget.labelTextStyle,
          hintText: widget.hintText,
          hintStyle: widget.hintTextStyle,
          prefix: widget.prefix,
          prefixIcon: widget.prefixIcon == null
              ? _buildPrefixIcon()
              : widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          filled: widget.isFilled,
          fillColor: widget.filledColor,
          errorText: widget.errorText,
          error: widget.error,
          errorBorder: widget.isOutlineBorder
              ? OutlineInputBorder(
                  borderSide: errorBorderSide,
                  borderRadius: BorderRadius.circular(widget.borderRadius))
              : UnderlineInputBorder(
                  borderSide: errorBorderSide,
                ),
          focusedErrorBorder: widget.isOutlineBorder
              ? OutlineInputBorder(
                  borderSide: errorBorderSide,
                  borderRadius: BorderRadius.circular(widget.borderRadius))
              : UnderlineInputBorder(
                  borderSide: errorBorderSide,
                )),
      cursorColor: widget.cursorColor,
      cursorWidth: widget.cursorWidth,
      maxLength: widget.maxLength,
      onChanged: (String value) {
        // var checked;
        if (widget.onChanged != null) {
          widget.onChanged!(value, widget.controller);
        }
        if (widget.streamController != null) {
          widget.streamController!.sink.add(value);
        }
      },
      textAlign: widget.textAlign == null ? TextAlign.left : widget.textAlign!,
    );
  }

  @override
  Widget build(BuildContext context) => _buildTextFormField(context);
}

// thoughts
// when the TextInputAction variable is initialized, there has to be an
// onFieldSubmitted callback too

import 'package:flutter/material.dart';

import '../../../core/constance/style.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final TextStyle? textStyle;
  final Color color;
  final BorderRadius? borderRadius;
  final double? elevation;
  final double? height;
  final double? width;

  const CustomButton({
    Key? key,
    this.onTap,
    required this.text,
    this.height,
    this.width,
    this.color = primaryColor,
    this.borderRadius,
    this.elevation,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.maxFinite,
      height: height ?? 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          elevation: elevation ?? 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: textStyle ??
              const TextStyle(
                color: backgroundColor,
                fontSize: 14,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

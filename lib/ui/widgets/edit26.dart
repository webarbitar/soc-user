import 'package:flutter/material.dart';

import '../../core/constance/style.dart';

class Edit26 extends StatefulWidget {
  final String hint;
  final Function(String)? onChangeText;
  final Function()? onSuffixIconPress;
  final Function()? onTap;
  final void Function(String)? onSubmit;
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  final TextInputType type;
  final Color color;
  final Color borderColor;
  final IconData icon;
  final IconData? suffixIcon;
  final TextStyle style;
  final double radius;
  final bool useAlpha;

  const Edit26(
      {Key? key,
      this.hint = "",
      required this.controller,
      this.type = TextInputType.text,
      this.color = Colors.black,
      this.radius = 0,
      this.onChangeText,
      required this.icon,
      this.borderColor = Colors.transparent,
      this.style = const TextStyle(),
      this.useAlpha = true,
      this.onTap,
      this.suffixIcon,
      this.onSuffixIconPress,
      this.onSubmit,
      this.textInputAction})
      : super(key: key);

  @override
  _Edit26State createState() => _Edit26State();
}

class _Edit26State extends State<Edit26> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: decor,
        child: Center(
          child: TextFormField(
            obscureText: false,
            cursorColor: widget.style.color,
            keyboardType: widget.type,
            controller: widget.controller,
            onFieldSubmitted: widget.onSubmit,
            textInputAction: widget.textInputAction,
            onTap: () async {
              if (widget.onTap != null) widget.onTap!();
            },
            onChanged: (String value) async {
              if (widget.onChangeText != null) widget.onChangeText!(value);
            },
            textAlignVertical: TextAlignVertical.center,
            style: widget.style,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                widget.icon,
                color: primaryColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  widget.suffixIcon,
                  color: primaryColor,
                ),
                onPressed: () {
                  if (widget.onSuffixIconPress != null) widget.onSuffixIconPress!();
                },
              ),
              hintText: widget.hint,
              hintStyle: widget.style,
            ),
          ),
        ));
  }
}

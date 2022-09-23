import 'package:flutter/material.dart';

import '../../core/constance/style.dart';

class Edit43 extends StatefulWidget {
  final String text;
  final TextStyle hintStyle;
  final String hint;
  final TextStyle editStyle;
  final Function(String)? onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Color color;
  final Widget? prefixIcon;
  final bool needDecoration;

  Edit43(
      {this.hint = "",
      required this.controller,
      this.type = TextInputType.text,
      this.color = Colors.grey,
      this.prefixIcon,
      this.onChangeText,
      this.text = "",
      this.hintStyle = const TextStyle(),
      this.editStyle = const TextStyle(),
      this.needDecoration = true});

  @override
  _Edit43State createState() => _Edit43State();
}

class _Edit43State extends State<Edit43> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    var _icon = Icons.visibility_off;
    if (!_obscure) _icon = Icons.visibility;

    var _sicon2 = IconButton(
      iconSize: 20,
      icon: Icon(
        _icon,
        color: widget.color,
      ),
      onPressed: () {
        setState(() {
          _obscure = !_obscure;
        });
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(widget.text, style: widget.textStyle),
        Container(
          height: 40,
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: widget.needDecoration ? decor : null,
          child: TextField(
            controller: widget.controller,
            onChanged: (String value) async {},
            cursorColor: Colors.black,
            style: widget.editStyle,
            cursorWidth: 1,
            obscureText: _obscure,
            textAlign: TextAlign.left,
            maxLines: 1,
            decoration: InputDecoration(
              suffixIcon: _sicon2,
              prefixIcon: widget.prefixIcon,
              enabledBorder: const UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              hintText: widget.hint,
              hintStyle: widget.hintStyle,
            ),
          ),
        )
      ],
    );
  }
}

class Edit43a extends StatefulWidget {
  final String text;
  final TextStyle hintStyle;
  final String hint;
  final TextStyle editStyle;
  final Function(String)? onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Color color;
  final Widget? prefixIcon;
  final bool needDecoration;

  Edit43a(
      {this.hint = "",
      required this.controller,
      this.type = TextInputType.text,
      this.color = Colors.grey,
      this.prefixIcon,
      this.onChangeText,
      this.text = "",
      this.hintStyle = const TextStyle(),
      this.editStyle = const TextStyle(),
      this.needDecoration = false});

  @override
  _Edit43aState createState() => _Edit43aState();
}

class _Edit43aState extends State<Edit43a> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(widget.text, style: widget.textStyle),
        Container(
          height: 40,
          decoration: widget.needDecoration ? decor : null,
          child: TextField(
            controller: widget.controller,
            onChanged: (String value) async {},
            cursorColor: Colors.black,
            style: widget.editStyle,
            cursorWidth: 1,
            keyboardType: widget.type,
            textAlign: TextAlign.left,
            maxLines: 1,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              enabledBorder: const UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              hintText: widget.hint,
              hintStyle: widget.hintStyle,
            ),
          ),
        )
      ],
    );
  }
}

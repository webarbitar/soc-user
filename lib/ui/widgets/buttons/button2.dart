import 'package:flutter/material.dart';

import '../../../core/constance/style.dart';

button2(String text, Color color, double _radius, Function _callback, bool enable) {
  return Stack(
    children: <Widget>[
      Container(
          width: double.maxFinite,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          )),
      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: () {
                  _callback();
                }, // needed
              )),
        )
    ],
  );
}

button2s(String text, TextStyle style, Color color, double _radius, Function _callback, bool enable,
    {EdgeInsetsGeometry? padding, double? width = double.maxFinite}) {
  return Stack(
    children: <Widget>[
      Container(
          width: width,
          padding: padding ?? const EdgeInsets.only(top: 12, bottom: 12),
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: Text(
            text,
            style: style,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          )),
      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: () {
                  _callback();
                }, // needed
              )),
        )
    ],
  );
}

button2sg(String text, TextStyle style, Color color, double _radius, Function _callback,
    bool enable, Color colorBkg) {
  return Stack(
    children: <Widget>[
      Container(
          width: double.maxFinite,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: colorBkg,
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: Text(
            text,
            style: style,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          )),
      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: () {
                  _callback();
                }, // needed
              )),
        )
    ],
  );
}

button2a(String text, TextStyle style, String text2, TextStyle style2, Color color, double _radius,
    Function _callback, bool enable) {
  return Stack(
    children: <Widget>[
      Container(
          width: double.maxFinite,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(theme.radius),
            border: Border.all(color: Colors.grey.withAlpha(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(1, 1),
              ),
            ],
          )
          // BoxDecoration(
          //   color: (enable) ? color : Colors.grey.withOpacity(0.5),
          //   borderRadius: BorderRadius.circular(_radius),
          // )
          ,
          child: Column(
            children: [
              Text(
                text,
                style: style,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                text2,
                style: style2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          )),
      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: () {
                  _callback();
                }, // needed
              )),
        )
    ],
  );
}

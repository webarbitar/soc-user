import 'package:flutter/material.dart';

import '../../../core/constance/style.dart';

button126(String text, List<Color> gradient, String icon, double width, double height,
    double radius, Function _callback, bool enable) {
  return Stack(
    children: <Widget>[
      Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(10),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Column(
            children: [
              Expanded(
                  child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(radius), topRight: Radius.circular(radius)),
                        gradient: (enable)
                            ? LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: gradient,
                              )
                            : LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.grey.withOpacity(0.5),
                                  Colors.grey.withOpacity(0.5)
                                ],
                              )),
                  ),
                  Container(
                      width: width,
                      height: height,
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        icon,
                        fit: BoxFit.contain,
                      )),
                ],
              )),
              Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    text,
                    style: theme.style10W400,
                    textAlign: TextAlign.center,
                  ))
            ],
          )),
      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
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

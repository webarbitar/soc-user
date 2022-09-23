import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

button202a(String text, TextStyle style, Color color, String image, double width, double height,
    double radius, Function _callback) {
  return Stack(
    children: <Widget>[
      Container(
          margin: EdgeInsets.all(5),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
            //   boxShadow: [
            // BoxShadow(
            //   color: Colors.grey.withOpacity(0.3),
            //   spreadRadius: 3,
            //   blurRadius: 5,
            //   offset: Offset(3, 3),
            // ),
            // ],
          ),
          child: Column(
            children: [
              Expanded(
                  child: ClipRRect(
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(radius), topRight: Radius.circular(radius)),
                child: Container(
                  width: width,
                  height: height,
                  child: image.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: image,
                          imageBuilder: (context, imageProvider) => Container(
                                //width: double.maxFinite,
                                //alignment: Alignment.bottomRight,
                                child: Container(
                                  width: height,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  )),
                                ),
                              ))
                      : Container(),

                  // Image.asset(image,
                  //   fit: BoxFit.cover,
                  // )
                ),
              )),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: style,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          )),
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

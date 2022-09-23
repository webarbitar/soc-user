import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constance/strings.dart';
import '../../../core/constance/style.dart';


button202y(
    String text,
    TextStyle style,
    String text2,
    TextStyle style2,
    String textPrice,
    TextStyle stylePrice,
    String textDiscPrice,
    TextStyle styleDiscPrice,
    int stars,
    Color iconStarsColor,
    Color color,
    String image,
    double width,
    double radius,
    bool favorite,
    Function(bool) setFavorite,
    String sale,
    TextStyle styleSale,
    bool unavailable,
    Function() _callback) {
  return Stack(
    children: <Widget>[
      Container(
          margin: EdgeInsets.only(bottom: 5),
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                  child: ClipRRect(
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(radius), topRight: Radius.circular(radius)),
                child: Container(
                    width: width,
                    child: Stack(
                      children: [
                        image.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: image,
                                imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ))
                            : Container(),
                        if (unavailable)
                          Container(
                            color: Colors.black.withAlpha(50),
                            child: Center(
                                child: Text(
                              strings.get(30),
                              style: theme.style10W800White,
                              textAlign: TextAlign.center,
                            )),

                            /// Not available Now
                          )
                      ],
                    )),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      text2,
                      style: style2,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Text(
                        textPrice,
                        style: stylePrice,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        textDiscPrice,
                        style: styleDiscPrice,
                      ),
                      Expanded(
                          child: SizedBox(
                        width: 3,
                      )),
                      Icon(
                        Icons.star,
                        color: iconStarsColor,
                        size: 16,
                      ),
                      Text(
                        stars.toString(),
                      ),
                    ]),
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
      ),
      Positioned.fill(
          child: Container(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {
                    setFavorite(!favorite);
                  },
                  child: (favorite)
                      ? Icon(
                          Icons.favorite,
                          size: 20,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.favorite_border,
                          size: 18,
                          color: Colors.grey,
                        ),
                ),
              ))),
      if (sale.isNotEmpty)
        Positioned.fill(
            child: Container(
          alignment: Alignment.topLeft,
          child: Container(
              padding: EdgeInsets.all(3),
              color: Colors.green,
              margin: EdgeInsets.only(top: 8),
              child: Text(
                sale,
                style: styleSale,
              )),
        )),
    ],
  );
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constance/strings.dart';
import '../../../core/constance/style.dart';


button202m(
    String text,
    TextStyle style,
    String text2,
    TextStyle style2,
    String text3,
    TextStyle style3,
    int stars,
    Color iconStarsColor,
    Color color,
    String image,
    double radius,
    bool favorite,
    Function(bool) setFavorite,
    double height,
    bool unavailable,
    Function() _callback,
    {bool favoriteEnable = true}) {
  return Stack(
    children: <Widget>[
      Container(
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 20, top: 5),
                    child: ClipRRect(
                        borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            bottomLeft: Radius.circular(radius),
                            topRight: Radius.circular(radius),
                            bottomRight: Radius.circular(radius)),
                        child: Stack(
                          children: [
                            image.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: image,
                                    imageBuilder: (context, imageProvider) => Container(
                                      height: height - 20,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      )),
                                    ),
                                  )
                                : Container(),
                            if (unavailable)
                              Container(
                                height: height - 20,
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
              Expanded(
                  flex: 4,
                  child: Column(
                    children: [
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(children: [
                              if (stars >= 1)
                                Icon(
                                  Icons.star,
                                  color: iconStarsColor,
                                  size: 16,
                                ),
                              if (stars < 1)
                                Icon(
                                  Icons.star_border,
                                  color: iconStarsColor,
                                  size: 16,
                                ),
                              if (stars >= 2)
                                Icon(
                                  Icons.star,
                                  color: iconStarsColor,
                                  size: 16,
                                ),
                              if (stars < 2)
                                Icon(
                                  Icons.star_border,
                                  color: iconStarsColor,
                                  size: 16,
                                ),
                              if (stars >= 3)
                                Icon(
                                  Icons.star,
                                  color: iconStarsColor,
                                  size: 16,
                                ),
                              if (stars < 3)
                                Icon(
                                  Icons.star_border,
                                  color: iconStarsColor,
                                  size: 16,
                                ),
                              if (stars >= 4)
                                Icon(
                                  Icons.star,
                                  color: iconStarsColor,
                                  size: 16,
                                ),
                              if (stars < 4)
                                Icon(
                                  Icons.star_border,
                                  color: iconStarsColor,
                                  size: 16,
                                ),
                              if (stars >= 5)
                                Icon(
                                  Icons.star,
                                  color: iconStarsColor,
                                  size: 16,
                                ),
                              if (stars < 5)
                                Icon(
                                  Icons.star_border,
                                  color: iconStarsColor,
                                  size: 16,
                                ),
                              Text(
                                stars.toString(),
                              ),
                            ]),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  text3,
                                  style: style3,
                                )),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
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
      if (favoriteEnable)
        Positioned.fill(
            child: Container(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      setFavorite(!favorite);
                    },
                    child: (favorite)
                        ? Icon(
                            Icons.favorite,
                            size: 25,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.favorite_border,
                            size: 22,
                            color: Colors.grey,
                          ),
                  ),
                )))
    ],
  );
}

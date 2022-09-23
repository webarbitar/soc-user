import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:socspl/core/modal/category/child_category_modal.dart';

import '../../../core/constance/strings.dart';
import '../../../core/constance/style.dart';

button202z(
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
    Function _callback,
    bool _decoration) {
  return Stack(
    children: <Widget>[
      Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.all(8),
          width: width,
          decoration: _decoration
              ? BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(1, 1),
                    ),
                  ],
                )
              : const BoxDecoration(),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: SizedBox(
                      width: width,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: image,
                            width: width,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              )),
                            ),
                            errorWidget: (context, url, error) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade100,
                                ),
                                child: const Center(
                                  child: Text("No image"),
                                ),
                              );
                            },
                          ),
                          if (unavailable)
                            Container(
                              color: Colors.black.withAlpha(50),
                              child: Center(
                                  child: Text(
                                strings.get(30),
                                style: theme.style10W800White,
                                textAlign: TextAlign.center,
                              )),
                            )
                        ],
                      )),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text,
                              style: style,
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              text2,
                              style: style2,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
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
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  textPrice,
                                  style: stylePrice,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  textDiscPrice,
                                  style: styleDiscPrice,
                                ),
                                const Expanded(
                                    child: SizedBox(
                                  width: 3,
                                )),
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
      Positioned.fill(
          child: Container(
              alignment: _decoration ? Alignment.bottomRight : Alignment.topRight,
              child: Container(
                margin: _decoration
                    ? const EdgeInsets.all(8)
                    : const EdgeInsets.only(left: 8, right: 8, top: 38),
                child: InkWell(
                  onTap: () {
                    setFavorite(!favorite);
                  },
                  child: (favorite)
                      ? const Icon(
                          Icons.favorite,
                          size: 20,
                          color: Colors.green,
                        )
                      : const Icon(
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
              padding: const EdgeInsets.all(3),
              color: Colors.green,
              margin: const EdgeInsets.only(top: 8),
              child: Text(
                sale,
                style: styleSale,
              )),
        )),
    ],
  );
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../../core/modal/cart/cart_model.dart';
import '../../../../core/modal/service/category_service_modal.dart';
import '../../../../core/utils/storage/storage.dart';
import '../../../../core/view_modal/cart/cart_view_model.dart';
import '../../../shared/divider/dotted_divider.dart';
import '../../../shared/navigation/navigation.dart';
import '../../../shared/ui_helpers.dart';

class ServiceWidget extends StatelessWidget {
  final CategoryServiceModal data;
  final VoidCallback onTap;
  final Widget redirectRoute;

  const ServiceWidget(
      {Key? key, required this.data, required this.onTap, required this.redirectRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: 4.75,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      itemCount: 5,
                      itemSize: 14.0,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(width: 6),
                    const Text("4.75 (2.3K)")
                  ],
                ),
                UIHelper.verticalSpaceSmall,
                Text(
                  "₹ ${data.prices.first.price}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                UIHelper.verticalSpaceSmall,
                const DottedDivider(color: Colors.black12),
                UIHelper.verticalSpaceSmall,
                Html(
                  data: data.description,
                  style: {
                    "body": Style(
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                      fontFamily: "Montserrat",
                      fontSize: FontSize.em(0.88),
                      fontWeight: FontWeight.w500,
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                    ),
                  },
                ),
                IgnorePointer(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                    onPressed: () {},
                    child: const Text(
                      "View details",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          UIHelper.horizontalSpaceMedium,
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: data.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: data.imageUrl,
                            width: 130,
                          )
                        : const SizedBox(
                            width: 130,
                            height: 90,
                            child: Center(
                              child: Text(
                                "No image",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 30,
                right: 30,
                child: Consumer<CartViewModel>(
                  builder: (context, CartViewModel model, _) {
                    CartItem? cart = model.containsService(data);
                    if (cart != null) {
                      return Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(4),
                        color: Theme.of(context).primaryColor,
                        child: SizedBox(
                          height: 30,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (cart.additionalItem.isNotEmpty) {
                                      onTap();
                                    } else {
                                      model.decreaseServiceQty(cart);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "${cart.totalQuantity}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    softWrap: false,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (cart.additionalItem.isNotEmpty) {
                                      onTap();
                                    } else {
                                      model.increaseServiceQty(cart);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            if (Storage.instance.isLogin) {
                              if (cart != null) {
                                model.increaseServiceQty(cart);
                              } else {
                                var price = 0;
                                if (data.prices.isNotEmpty) {
                                  price = data.prices.first.price;
                                }
                                model.addServiceToCart(
                                  CartItem(
                                    service: data,
                                    quantity: 1,
                                    totalPrice: price,
                                  ),
                                );
                              }
                            } else {
                              Navigation.instance.navigate("/login", args: redirectRoute);
                            }
                          },
                          child: const Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';
import 'package:socspl/ui/views/service/service_view.dart';

import '../../../core/view_modal/cart/cart_view_model.dart';
import '../../shared/navigation/navigation.dart';

class ServiceDetailsView extends StatefulWidget {
  final int categoryId;
  final int serviceId;

  const ServiceDetailsView({Key? key, required this.serviceId, required this.categoryId})
      : super(key: key);

  @override
  State<ServiceDetailsView> createState() => _ServiceDetailsViewState();
}

class _ServiceDetailsViewState extends State<ServiceDetailsView> {
  @override
  void initState() {
    super.initState();
    final homeModel = context.read<HomeViewModal>();
    final cat = homeModel.categories.singleWhere((el) => el.id == widget.categoryId);
    context.read<CartViewModel>().initCartModule(cat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Consumer(builder: (context, CartViewModel model, _) {
        if (!model.isPresent) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 14,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "₹ ${model.totalPrice}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  width: 160,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigation.instance.navigate("/cart");
                    },
                    child: const Text(
                      "View Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Montserrat",
                        fontSize: 14,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      body: AddOnViewWidget(
        serviceId: widget.serviceId,
        isDraggable: false,
        redirectRoute: ServiceDetailsView(
          categoryId: widget.categoryId,
          serviceId: widget.serviceId,
        ),
      ),
    );
  }
}

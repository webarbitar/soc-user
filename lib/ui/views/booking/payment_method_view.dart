import 'package:flutter/material.dart';
import 'package:socspl/core/constance/style.dart';
import 'package:socspl/ui/shared/ui_helpers.dart';
import 'package:socspl/ui/shared/validator_mixin.dart';
import 'package:socspl/ui/widgets/custom/custom_button.dart';

class PaymentMethodView extends StatefulWidget {
  final Function(String) onSelected;

  const PaymentMethodView({Key? key, required this.onSelected}) : super(key: key);

  @override
  State<PaymentMethodView> createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
  final _methodNfy = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.2),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder(
            valueListenable: _methodNfy,
            builder: (context, String? value, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIHelper.verticalSpaceSmall,
                  const Text(
                    "Choose a Payment Method",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [dropShadow]),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Get 10% cashback up to ₹50",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Pay with UPI T&C apply.",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Link you bank account now",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 11,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        UIHelper.verticalSpaceSmall,
                        const Icon(
                          Icons.keyboard_arrow_right_outlined,
                          color: Colors.black54,
                        )
                      ],
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
                  InkWell(
                    onTap: () {
                      _methodNfy.value = "paytm";
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [dropShadow]),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                      child: Row(
                        children: [
                          Radio(
                              value: "paytm",
                              groupValue: _methodNfy.value,
                              onChanged: (value) {
                                _methodNfy.value = value!;
                              }),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Pay with Debit/Credit/ATM/Paytm",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Pay online with debit/credit cards. Paytm wallet or Other UPI payment",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 12,
                                    height: 1.2,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                        ],
                      ),
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
                  InkWell(
                    onTap: () {
                      _methodNfy.value = "cod";
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [dropShadow]),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                      child: Row(
                        children: [
                          Radio(
                              value: "cod",
                              groupValue: _methodNfy.value,
                              onChanged: (value) {
                                _methodNfy.value = value!;
                              }),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Cash on Delivery/Pay on Delivery",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Pay on service delivery or after service completion ",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 12,
                                    height: 1.2,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                        ],
                      ),
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
                  UIHelper.verticalSpaceSmall,
                  CustomButton(
                    text: "Continue",
                    onTap: () {
                      if (value == null) {
                        showErrorMessage('Payment method required');
                        return;
                      }
                      widget.onSelected(value);
                    },
                  ),
                  UIHelper.verticalSpaceMedium,
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [dropShadow]),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.verified_user_outlined, color: Colors.black54),
                        UIHelper.horizontalSpaceMedium,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Get 100% Purchase Protection",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Secure Payment",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 11,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2),
                            ],
                          ),
                        ),
                        UIHelper.verticalSpaceSmall,
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

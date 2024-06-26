import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/common/widgets/loaders/loader.dart';
import 'package:shoe_admin/common/widgets/product/cart/cart_item.dart';
import 'package:shoe_admin/common/widgets/product/cart/coupon_widget.dart';
import 'package:shoe_admin/common/widgets/succes_screen/succes_screen.dart';
import 'package:shoe_admin/features/shop/controllers/product/cart_controller.dart';
import 'package:shoe_admin/features/shop/controllers/product/order_controller.dart';
import 'package:shoe_admin/features/shop/screens/cart/widgets/cart_item.dart';
import 'package:shoe_admin/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:shoe_admin/navigation_menu.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';
import 'package:shoe_admin/utils/helpers/pricing_caculator.dart';

import 'widgets/billing_address_section.dart';
import 'widgets/billing_payment_section.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final cartController = CartController.instance;
    final subTotal = cartController.totalCartPrice.value;
    final orderController = Get.put(OrderController());
    final totalAmount = TPricingCalculator.calculateTotalPrice(subTotal, 'US');

    return Scaffold(
      appBar: TAppbar(
        title: Text('Order Review',
            style: TextStyle(
                fontSize: 20, color: dark ? TColors.white : TColors.dark)),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///item in cart
              const TCartItems(
                showAddRemoveButtons: false,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              ///coupon TextField
              const TCouponCode(),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              ///billing section
              TRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.black : TColors.white,
                child: const Column(
                  children: [
                    ///pricing
                    TBillingAmountSection(),
                    SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    ///divider
                    Divider(),
                    SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    ///payment methods
                    TBillingPaymentSection(),
                    SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    ///address
                    TBillingAddressSection()
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      ///checkout buttons
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: subTotal > 0
              ? () => orderController.processOrder(totalAmount)
              : () => TLoaders.warningSnackBar(title: 'Empty Cart',message: 'Add items in the cart in order to proceed'),
          child:  Text('Checkout \$$totalAmount'),
        ),
      ),
    );
  }
}

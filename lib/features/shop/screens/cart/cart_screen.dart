import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/icon/circular_icon.dart';
import 'package:shoe_admin/common/widgets/images/rounded_image.dart';
import 'package:shoe_admin/common/widgets/loaders/animation_loader.dart';
import 'package:shoe_admin/common/widgets/product/cart/add_remove_button.dart';
import 'package:shoe_admin/common/widgets/product/cart/cart_item.dart';
import 'package:shoe_admin/common/widgets/product/product_carts/product_price_text.dart';
import 'package:shoe_admin/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:shoe_admin/common/widgets/text/product_title.dart';
import 'package:shoe_admin/features/shop/controllers/product/cart_controller.dart';
import 'package:shoe_admin/features/shop/screens/checkout/checkout.dart';
import 'package:shoe_admin/navigation_menu.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

import 'widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = CartController.instance;

    return Scaffold(
      appBar: TAppbar(
        title: Text('Cart',
            style: TextStyle(
                fontSize: 20, color: dark ? TColors.white : TColors.dark)),
        showBackArrow: true,
      ),
      body: Obx(() {
        ///nothing found widget
        final emptyWidget = TAnimationLoaderWidget(
          text: 'Cart is Empty.',
          animation: TImages.emptyCart,
          showAction: true,
          actionText: 'Let\'s fill it',
          onActionPressed: () => Get.off(() => const NavigationMenu()),
        );

        if (controller.cartItems.isEmpty) {
          return emptyWidget;
        } else {
          return const Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),

            ///item in cart
            child: TCartItems(
              showAddRemoveButtons: true,
            ),
          );
        }
      }),

      ///checkout buttons
      bottomNavigationBar: controller.cartItems.isEmpty
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: ElevatedButton(
                onPressed: () => Get.to(() => const CheckoutScreen()),
                child: Obx(() =>
                    Text('Checkout \$${controller.totalCartPrice.value}')),
              ),
            ),
    );
  }
}

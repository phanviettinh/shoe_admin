import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/features/shop/controllers/product/cart_controller.dart';
import 'package:shoe_admin/features/shop/screens/cart/cart_screen.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class TCartCounterIcon extends StatelessWidget {
  const TCartCounterIcon({
    super.key,
    this.iconColor,
    this.counterBgColor,
    this.counterTextColor,
  });

  final Color? iconColor, counterBgColor, counterTextColor;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(CartController());

    return Stack(
      children: [
        IconButton(
            onPressed: () => Get.to(() => const CartScreen()),
            icon: const Icon(Iconsax.shopping_bag),
            color: iconColor),
        Positioned(
            right: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                  color: counterBgColor ?? (dark ? TColors.white: TColors.black),
                  borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: Obx(
                    () => Text(
                      controller.noOfCartItem.value.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .apply(color: counterTextColor ?? (dark ? TColors.black : TColors.white), fontSizeFactor: 0.8),
                    )
                ),
              ),
            ))
      ],
    );
  }
}

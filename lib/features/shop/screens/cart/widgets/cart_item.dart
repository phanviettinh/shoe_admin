import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/product/cart/add_remove_button.dart';
import 'package:shoe_admin/common/widgets/product/cart/cart_item.dart';
import 'package:shoe_admin/common/widgets/product/product_carts/product_price_text.dart';
import 'package:shoe_admin/features/shop/controllers/product/cart_controller.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({
    super.key,
    this.showAddRemoveButtons = false,
  });

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;

    return Obx(() => ListView.separated(
          separatorBuilder: (_, __) => const SizedBox(
            height: TSizes.spaceBtwSections,
          ),
          itemCount: cartController.cartItems.length,
          shrinkWrap: true,
          itemBuilder: (_, index) => Obx(() {
            final item = cartController.cartItems[index];
            return Column(
              children: [
                ///title, price, size
                TCartItem(
                  cartItem: item,
                ),
                if (showAddRemoveButtons)
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                if (showAddRemoveButtons)
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ///extra space
                          const SizedBox(
                            width: 70,
                          ),

                          ///add remove button
                          TProductQuantityWithAddRemoveButton(
                            quantity: item.quantity,
                            add: () => cartController.addOneToCart(item),
                            remove: () => cartController.removeOneFromCart(item),
                          ),
                        ],
                      ),

                      ///price
                      TProductPriceText(price: (item.price * item.quantity).toStringAsFixed(1))
                    ],
                  )
              ],
            );
          }),
        ));
  }
}

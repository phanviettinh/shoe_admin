import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/chips/choice_chip.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/common/widgets/product/product_carts/product_price_text.dart';
import 'package:shoe_admin/common/widgets/text/product_title.dart';
import 'package:shoe_admin/common/widgets/text/section_heading.dart';
import 'package:shoe_admin/features/shop/controllers/product/variation_controller.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class TProductAttribute extends StatelessWidget {
  const TProductAttribute({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(VariationController());
    return Obx(() => Column(
      children: [
        ///selected attributes pricing and description
        //display variation price and stock when some variation is selected
        if(controller.selectedVariation.value.id.isNotEmpty)
          TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.md),
            backgroundColor: dark ? TColors.darkerGrey : TColors.grey,
            child: Column(
              children: [
                ///title, price and stock status
                Row(
                  children: [
                    const TSectionHeading(title: 'Variation',showActionButton: false,),
                    const SizedBox(width: TSizes.defaultSpace,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const TProductTextTitle(title: 'price: ',smallSize: true,),
                            const SizedBox(width: TSizes.spaceBtwItems / 2,),

                            ///actual price
                            if(controller.selectedVariation.value.salePrice > 0)
                              Text('\$${controller.selectedVariation.value.price}',style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough),),
                            const SizedBox(width: TSizes.spaceBtwItems,),

                            ///sale price
                            TProductPriceText(price: controller.getVariationPrice()),

                          ],
                        ),

                        ///stock
                        Row(
                          children: [
                            const TProductTextTitle(title: 'Stock: ',smallSize: true,),
                            const SizedBox(width: TSizes.spaceBtwItems / 2,),
                            Text(controller.variationStockStatus.value,style: Theme.of(context).textTheme.titleMedium,)
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2,),

                ///variation description
                const TProductTextTitle(
                  title: 'This is the Description of the Product and it can go up to max 4 lines.',
                  smallSize: true,
                  maxLines: 4,
                )
              ],
            ),
          ),
        const SizedBox(height: TSizes.spaceBtwItems ,),

        /// attributes
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: product.productAttributes!.map((attribute) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TSectionHeading(title: attribute.name ?? '',showActionButton: false,),
                const SizedBox(height: TSizes.spaceBtwItems / 2,),
                Obx(() => Wrap(
                    spacing: 8,
                    children: attribute.values!.map((attributeValue) {
                      final isSelected  = controller.selectedAttributes[attribute.name] == attributeValue;
                      final available = controller
                          .getAttributeAvailabilityInVariation(product.productVariations!, attribute.name!)
                          .contains(attributeValue);

                      return TChoiceChip(text: attributeValue, selected: isSelected, onSelected: available ? (selected){
                        if(selected && available){
                          controller.onAttributeSelected(product, attribute.name ?? '', attributeValue);
                        }
                      } : null,);
                    }).toList()
                )
                )
              ],
            )
            ).toList()
        )
      ],
    ));
  }
}


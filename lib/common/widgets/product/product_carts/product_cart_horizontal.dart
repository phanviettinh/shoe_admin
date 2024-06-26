import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/common/styles/shadows.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/common/widgets/icon/circular_icon.dart';
import 'package:shoe_admin/common/widgets/images/rounded_image.dart';
import 'package:shoe_admin/common/widgets/product/favourite_icon/favourite_icon.dart';
import 'package:shoe_admin/common/widgets/product/product_carts/product_price_text.dart';
import 'package:shoe_admin/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:shoe_admin/common/widgets/text/product_title.dart';
import 'package:shoe_admin/features/shop/controllers/product/product_controller.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/features/shop/screens/product_details/product_details.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/enums.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class TProductCartHorizontal extends StatelessWidget {
  const TProductCartHorizontal({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = ProductController.instance;
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);

    return GestureDetector(
      onTap: () => Get.to(() =>  ProductDetail(product: product,)),
      child:  Container(
        width: 260,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TSizes.productImageRadius),
            color: dark ? TColors.darkerGrey : TColors.lightContainer
        ),
        child: Row(
          children: [
            ///thumbnail
            TRoundedContainer(
              height: 120,
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: dark  ? TColors.dark : TColors.white,
              child:  Stack(
                children: [
                  ///thumbnail image
                  SizedBox(
                    height: 120,
                    width: 100,
                    child: TRoundedImage(imageUrl: product.thumbnail,applyImageRadius: true,isNetworkImage: true,backgroundColor: TColors.light,),
                  ),

                  if(salePercentage != null)
                    Positioned(
                        top: 12,
                        child: TRoundedContainer(
                          radius: TSizes.sm,
                          backgroundColor: TColors.secondary.withOpacity(0.8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.sm, vertical: TSizes.xs),
                          child: Text(
                            '$salePercentage%',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .apply(color: TColors.black),
                          ),
                        )),

                  ///favourite icon button
                  Positioned(
                      top: 0,
                      right: 0,
                      child: TFavouriteIcon(productId: product.id,)
                  )
                ],
              ),
            ),

            ///details
            SizedBox(
              width: 142,
              child: Padding(
                padding: const EdgeInsets.only(top: TSizes.sm,left: TSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TProductTextTitle(title: product.title,smallSize: true,),
                        const SizedBox(height: TSizes.spaceBtwItems / 2,),
                        TBrandTitleWithVerifiedIcon(title: product.brand!.name)
                      ],
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///price
                        Flexible(child: Column(
                          children: [
                            if(product.productType == ProductType.single.toString() && product.salePrice > 0)
                              Padding(
                                  padding: const EdgeInsets.only(left: TSizes.sm),
                                  child: Text(product.price.toString(),style: Theme.of(context).textTheme.labelMedium!.apply(decoration: TextDecoration.lineThrough),)
                              ) ,
                            Padding(
                                padding: const EdgeInsets.only(left: TSizes.sm),
                                child: TProductPriceText(price: controller.getProductPrice(product),)
                            )
                          ],
                        )),
                        ///add to cart
                        Container(
                          decoration: const BoxDecoration(
                              color: TColors.dark,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(TSizes.cardRadiusMd),
                                  bottomRight: Radius.circular(TSizes.productImageRadius)
                              )
                          ),
                          ///button add
                          child: const SizedBox(
                            width: TSizes.iconLg  * 1.2,
                            height: TSizes.iconLg * 1.2,
                            child: Center(child: Icon(Iconsax.add,color: TColors.white,),),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

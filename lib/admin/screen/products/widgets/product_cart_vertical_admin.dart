import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/admin/screen/products/add_products.dart';
import 'package:shoe_admin/admin/screen/products/widgets/product_detail_admin.dart';
import 'package:shoe_admin/common/styles/shadows.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/common/widgets/images/rounded_image.dart';
import 'package:shoe_admin/common/widgets/product/product_carts/product_price_text.dart';
import 'package:shoe_admin/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:shoe_admin/common/widgets/text/product_title.dart';
import 'package:shoe_admin/features/shop/controllers/all_product_controller.dart';
import 'package:shoe_admin/features/shop/controllers/product/product_controller.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/features/shop/screens/product_details/product_details.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/enums.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class TProductCartVerticalAdmin extends StatelessWidget {
  const TProductCartVerticalAdmin({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final controllerAll = AllProductController.instance;
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = THelperFunctions.isDarkMode(context);

    return Slidable(
      key: Key(product.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [

          ///update
          SlidableAction(
            onPressed: (context) {

              Get.to(() => AddProducts(product: product));

            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          ),

          ///delete
          SlidableAction(
            onPressed: (context) {
              // Delete product
              controllerAll.setProductData(product);
              _showDeleteConfirmationDialog(context, controllerAll, product.id);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Get.to((ProductDetailAdmin(product: product,))),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [TShadowStyle.verticalProductShadow],
                borderRadius: BorderRadius.circular(TSizes.productImageRadius),
                color: dark ? TColors.darkerGrey : TColors.light,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      /// thumbnail
                      TRoundedContainer(
                        width: 50,
                        height: 50,
                        backgroundColor: dark ? TColors.dark : TColors.light,
                        child: TRoundedImage(
                          imageUrl: product.thumbnail,
                          backgroundColor: TColors.light,
                          applyImageRadius: true,
                          isNetworkImage: true,
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Expanded(child: Text(product.title)),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Icon(Icons.notifications_active,color: product.isFeatured ? Colors.blue : Colors.red,)
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    children: [
                      /// stock
                      Text('Stock: ${product.stock}', style: Theme.of(context).textTheme.bodyMedium),
                      const Spacer(),
                      /// brand name
                      TBrandTitleWithVerifiedIcon(title: product.brand!.name, brandTextSizes: TextSizes.large),
                      const Spacer(),

                      /// price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (product.productType == ProductType.single.toString() && product.salePrice > 0)
                            Text(product.price.toString(), style: Theme.of(context).textTheme.labelMedium!.apply(decoration: TextDecoration.lineThrough)),
                          TProductPriceText(price: controller.getProductPrice(product)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (salePercentage != null)
          /// sale tag
            Positioned(
              top: 12,
              child: TRoundedContainer(
                radius: TSizes.sm,
                backgroundColor: TColors.secondary.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
                child: Text(
                  '$salePercentage%',
                  style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context, AllProductController controller, String productId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              controller.deleteProduct(productId);
            },
          ),
        ],
      );
    },
  );
}


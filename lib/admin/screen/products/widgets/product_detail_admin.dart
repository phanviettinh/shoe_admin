import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:shoe_admin/admin/screen/products/add_products.dart';
import 'package:shoe_admin/admin/screen/products/widgets/product_cart_vertical_admin.dart';
import 'package:shoe_admin/common/widgets/text/section_heading.dart';
import 'package:shoe_admin/features/shop/controllers/brand_controller.dart';
import 'package:shoe_admin/features/shop/controllers/product/product_controller.dart';
import 'package:shoe_admin/features/shop/models/brand_model.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/features/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:shoe_admin/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:shoe_admin/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:shoe_admin/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';

import '../../../../features/shop/screens/product_reviews/product_review.dart';
import '../../../../utils/constants/text_strings.dart';
import 'product_attribute_admin.dart';
import 'product_image_slider_admin.dart';
import 'product_meta_data_admin.dart';

class ProductDetailAdmin extends StatelessWidget {
  const ProductDetailAdmin({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            ///product slider image
            TProductImageSliderAdmin(product: product),

            ///product details
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace),
              child: Column(
                children: [

                  ///price, title, stock and brand
                  TProductMetaDataAdmin(product: product),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  ///Attributes
                  TProductAttributeAdmin(product: product),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  ///description
                  const TSectionHeading(
                      title: 'Description', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  ReadMoreText(
                    product.description ?? '',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Less',
                    moreStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),

                  ///review
                  const SizedBox(height: TSizes.spaceBtwSections),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/brands/brand_show_case.dart';
import 'package:shoe_admin/common/widgets/layouts/grid_layout.dart';
import 'package:shoe_admin/common/widgets/product/product_carts/product_cart_vertical.dart';
import 'package:shoe_admin/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shoe_admin/common/widgets/text/section_heading.dart';
import 'package:shoe_admin/features/shop/controllers/category_controller.dart';
import 'package:shoe_admin/features/shop/models/category_model.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/features/shop/screens/all_product/all_product.dart';
import 'package:shoe_admin/features/shop/screens/store/widgets/category_brand.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/cloud_helper_function.dart';

class TCategoryTab extends StatelessWidget {
  const TCategoryTab({super.key, required this.category});
  
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return  ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///brand
              CategoryBrands(category: category),
              const SizedBox(height: TSizes.spaceBtwItems,),

              ///product
              FutureBuilder(future: controller.getCategoryProducts(categoryId: category.id), builder: (context, snapshot){

                final response = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: const TVerticalProductShimmer());
                if(response != null) return response;

                ///record data
                final products = snapshot.data!;

                return Column(
                  children: [
                    TSectionHeading(
                      title: 'Your might like',
                      onPressed: () => Get.to(AllProductScreen(
                        title: category.name,
                        futureMethod: controller.getCategoryProducts(categoryId: category.id, limit: -1),)),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems,),
                    TGridLayout(
                        itemCount: products.length,
                        itemBuilder: (_,index) =>  TProductCartVertical(product: products[index])
                    ),
                  ],
                );
              }),
            ],
          ),
        )
      ],
    );
  }
}

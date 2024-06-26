import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:shoe_admin/common/widgets/layouts/grid_layout.dart';
import 'package:shoe_admin/common/widgets/product/product_carts/product_cart_vertical.dart';
import 'package:shoe_admin/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shoe_admin/common/widgets/text/section_heading.dart';
import 'package:shoe_admin/common/widgets/text/section_heading2.dart';
import 'package:shoe_admin/features/shop/controllers/product/product_controller.dart';
import 'package:shoe_admin/features/shop/screens/all_product/all_product.dart';
import 'package:shoe_admin/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:shoe_admin/features/shop/screens/home/widgets/home_category.dart';
import 'package:shoe_admin/features/shop/screens/home/widgets/home_slider.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///header
            const TPrimaryHeaderContainer(
              child: Column(
                children: [
                  ///appbar
                  THomeAppbar(),
                  SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  ///searchbar
                  TSearchContainer(
                    text: 'Search in store',
                  ),
                  SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  ///categories
                  Padding(
                    padding: EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        ///heading
                        TSectionHeading2(),
                        SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),

                        ///categories
                        THomeCategories()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: TSizes.spaceBtwSections,
                  )
                ],
              ),
            ),

            ///body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  ///banner
                  const TPromoSlider(),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  ///heading product
                  TSectionHeading(
                    title: 'Popular Products',
                    onPressed: () => Get.to(() => AllProductScreen(
                          title: 'Popular Products',

                          futureMethod: controller.fetchAllFeaturedProducts(),
                        )),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  ///product
                  Obx(() {
                    if (controller.isLoading.value) return const TVerticalProductShimmer();

                    if (controller.featuredProducts.isEmpty) {
                      return Center(
                        child: Text(
                          'No Data Found!',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }
                    return TGridLayout(
                      itemCount: controller.featuredProducts.length,
                      itemBuilder: (_, index) => TProductCartVertical(
                        product: controller.featuredProducts[index],
                      ),
                    );
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

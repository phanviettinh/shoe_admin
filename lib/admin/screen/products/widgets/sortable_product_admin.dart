import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/features/shop/controllers/all_product_controller.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';

import 'product_cart_vertical_admin.dart';

class TSortableProductAdmin extends StatelessWidget {
  const TSortableProductAdmin({
    super.key,
    required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductController());
    controller.assignProducts2(products);

    return Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

            ///searchbar
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                controller.filterProduct(value);
              },
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

            ///product
            Expanded(
              // Use Expanded to ensure ListView.builder has bounded height
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredProducts.isEmpty) {
                  return Center(
                    child: Text(
                      'No Products Found!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (_, index) {
                    final product = controller.filteredProducts[index];
                    return TProductCartVerticalAdmin(product: product);
                  },
                );
              }),
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/common/widgets/layouts/grid_layout.dart';
import 'package:shoe_admin/common/widgets/product/product_carts/product_cart_vertical.dart';
import 'package:shoe_admin/features/shop/controllers/all_product_controller.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';

class TSortableProduct extends StatelessWidget {
  const TSortableProduct({
    super.key, required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductController());
    controller.assignProducts(products);

    return Column(
      children: [
        ///Drop down
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          value: controller.selectedSortOption.value,
          onChanged: (value){
            controller.sortProducts(value!);
          },
          items: ['Name','Higher Price','Lower Price','Sale','Newest','Popularity']
              .map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
        ),
        const SizedBox(height: TSizes.spaceBtwSections,),

        ///product
        Obx(() => TGridLayout(itemCount: controller.products.length, itemBuilder: (_,index) =>  TProductCartVertical(product: controller.products[index],)))
      ],
    );
  }
}

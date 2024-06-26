import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/admin/screen/brands/add_brands_admin.dart';
import 'package:shoe_admin/admin/screen/products/widgets/sortable_product_admin.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/brands/brand_card.dart';
import 'package:shoe_admin/common/widgets/icon/circular_icon.dart';
import 'package:shoe_admin/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shoe_admin/features/shop/controllers/brand_controller.dart';
import 'package:shoe_admin/features/shop/models/brand_model.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/cloud_helper_function.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class UpdateDeleteBrand extends StatelessWidget {
  const UpdateDeleteBrand({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put((BrandController()));
    return Scaffold(
      appBar: TAppbar(
        title: Text(brand.name,
            style: TextStyle(
                fontSize: 20, color: dark ? TColors.white : TColors.dark)),
        showBackArrow: true,
        actions: [
          Row(
            children: [
              TCircularIcon(icon: Iconsax.edit,onPressed: () => Get.to(() => AddBrandsAdmin(brand: brand,))),
              const SizedBox(width: TSizes.spaceBtwItems,),
              TCircularIcon(icon: Icons.delete,onPressed: ()  {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text('Are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () => controller.deleteBrand(brand.id)
                    ),

                      ],
                    );
                  },
                );
              })

            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///brands detail
              TBrandCard(showBorder: true, brand: brand,),
              const SizedBox(height: TSizes.spaceBtwSections,),
            ],
          ),
        ),
      ),

    );
  }
}

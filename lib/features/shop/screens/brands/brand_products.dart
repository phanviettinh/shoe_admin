import 'package:flutter/material.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/brands/brand_card.dart';
import 'package:shoe_admin/common/widgets/product/sortable/sortable_product.dart';
import 'package:shoe_admin/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shoe_admin/features/shop/controllers/brand_controller.dart';
import 'package:shoe_admin/features/shop/models/brand_model.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/cloud_helper_function.dart';

class BrandProduct extends StatelessWidget {
  const BrandProduct({super.key, required this.brand});

  final BrandModel brand;
  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;

    return  Scaffold(
      appBar:  TAppbar(title: Text(brand.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///brands detail
              TBrandCard(showBorder: true, brand: brand,),
              const SizedBox(height: TSizes.spaceBtwSections,),

              FutureBuilder(future: controller.getBrandProducts(brandId: brand.id), builder: (context, snapshot){

                ///handle loader, no record, or error message
                const loader = TVerticalProductShimmer();
                final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);
                if(widget != null) return widget;

                ///record found!
                final brandProducts = snapshot.data!;
                return  TSortableProduct(products: brandProducts);
              })
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/layouts/grid_layout.dart';
import 'package:shoe_admin/common/widgets/product/product_carts/product_cart_vertical.dart';
import 'package:shoe_admin/common/widgets/product/sortable/sortable_product.dart';
import 'package:shoe_admin/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shoe_admin/features/shop/controllers/all_product_controller.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/cloud_helper_function.dart';

class AllProductScreen extends StatelessWidget {
  const AllProductScreen(
      {super.key, required this.title, this.query, this.futureMethod});

  final String title;
  final Query? query;
  final Future<List<ProductModel>>? futureMethod;

  @override
  Widget build(BuildContext context) {
    final controller =   Get.put(AllProductController());

    return Scaffold(
      appBar: TAppbar(
        title: Text(title),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: FutureBuilder(
                future: futureMethod ?? controller.fetchProductByQuery(query),
              builder: (context, snapshot) {

                  const loader = TVerticalProductShimmer();
                 final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);

                 if(widget != null) return widget;

                  //product found
                  final products = snapshot.data!;

                return  TSortableProduct(products: products,);
              }),
        ),
      ),
    );
  }
}

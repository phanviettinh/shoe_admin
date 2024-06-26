import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/icon/circular_icon.dart';
import 'package:shoe_admin/common/widgets/layouts/grid_layout.dart';
import 'package:shoe_admin/common/widgets/loaders/animation_loader.dart';
import 'package:shoe_admin/common/widgets/product/product_carts/product_cart_vertical.dart';
import 'package:shoe_admin/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shoe_admin/features/shop/controllers/product/favourite_controller.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/features/shop/screens/all_product/all_product.dart';
import 'package:shoe_admin/features/shop/screens/home/home_screen.dart';
import 'package:shoe_admin/navigation_menu.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/cloud_helper_function.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class WishList extends StatelessWidget {
  const WishList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavouritesController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return  Scaffold(
      backgroundColor: dark ? TColors.black : TColors.white,
      appBar: TAppbar(
        showBackArrow: false,
        title:  Text('Wishlist',style: TextStyle(fontSize: 20, color: dark ? TColors.white :  TColors.dark),),
        actions: [
          TCircularIcon(icon: Iconsax.add,onPressed: () => Get.to(const HomeScreen()))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Obx(
              () => FutureBuilder(future: controller.favouriteProducts(), builder: (context, snapshot){

                final emptyWidget = TAnimationLoaderWidget(
                  text: 'WishList is Empty...',
                  showAction: true,
                  actionText: 'Let\'s add some',
                  animation: TImages.wishlist,
                  onActionPressed: () => Get.off(() => const NavigationMenu()),
                );

                const loader = TVerticalProductShimmer(itemCount: 6,);
                final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader, nothingFound: emptyWidget);
                if(widget != null) return widget;

                final products = snapshot.data!;
                return TGridLayout(itemCount: products.length, itemBuilder: (_,index) =>  TProductCartVertical(product: products[index]));
              })
          )
        ),
      ),
    );
  }
}

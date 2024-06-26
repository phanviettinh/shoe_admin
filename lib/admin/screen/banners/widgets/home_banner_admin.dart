import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/common/widgets/images/rounded_image.dart';
import 'package:shoe_admin/common/widgets/shimmer/category_shimmer.dart';
import 'package:shoe_admin/features/shop/controllers/banner_controller.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class THomeBannerAdmin extends StatelessWidget {
  const THomeBannerAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());
    final dark = THelperFunctions.isDarkMode(context);

    return Obx(() {
      if (controller.isLoading.value) return const TCategoryShimmer();

      if (controller.filteredBanners.isEmpty) {
        return Center(
          child: Text(
            'No Data Found!',
            style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        itemCount: controller.filteredBanners.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (_, index) {
          final banner = controller.filteredBanners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0), // Adjust the spacing as needed
            child: Row(
              children: [
                TRoundedContainer(
                  width: 70,
                  height: 40,
                  backgroundColor: dark ? TColors.dark : TColors.light,
                  child: TRoundedImage(
                    imageUrl: banner.imageUrl,
                    backgroundColor: TColors.light,
                    applyImageRadius: true,
                    isNetworkImage: true,
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems,),
                Expanded(
                  child: Text(
                    banner.targetScreen,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems,),
                Expanded(
                  child: Text(
                    banner.active ? 'Active' : 'Inactive',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

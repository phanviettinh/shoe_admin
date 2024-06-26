import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:shoe_admin/common/widgets/images/rounded_image.dart';
import 'package:shoe_admin/common/widgets/shimmer/shimmer.dart';
import 'package:shoe_admin/features/shop/controllers/banner_controller.dart';
import 'package:shoe_admin/features/shop/controllers/home_controller.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';

class TPromoSlider extends StatelessWidget {
  const TPromoSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());

    return Obx(() {
      //loader
      if(controller.isLoading.value) return const TShimmerEffect(width: double.infinity, height: 190);

      //no data found
      if(controller.banners.isEmpty){
        return const Center(child: Text('No Data Found!'),);
      }else{
        return Column(
          children: [
            CarouselSlider(
              items: controller.banners
                  .map((banner) => TRoundedImage(
                imageUrl: banner.imageUrl,
                isNetworkImage: true,
                onPressed: () => Get.toNamed(banner.targetScreen),
              ))
                  .toList(),
              options: CarouselOptions(
                  viewportFraction: 1,
                  onPageChanged: (index, _) =>
                      controller.updatePageIndicator(index)),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            Center(
              child: Obx(() => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < controller.banners.length; i++)
                    TCircularContainer(
                      width: 20,
                      height: 4,
                      backgroundColor:
                      controller.carousalCurrentIndex.value == i
                          ? TColors.primaryColor
                          : TColors.grey,
                      margin: const EdgeInsets.only(right: 10),
                    ),
                ],
              )),
            )
          ],
        );
      }
    });
  }
}

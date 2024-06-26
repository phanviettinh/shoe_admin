import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/common/widgets/product/ratings/rating_indicator.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class TUserReviewCard extends StatelessWidget {
  const TUserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(backgroundImage: AssetImage(TImages.userReview3),),
                  const SizedBox(width: TSizes.spaceBtwItems,),
                Text('Phan Tinh',style: Theme.of(context).textTheme.titleLarge)
              ],
            ),
            IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert))
          ],
        ),
        const SizedBox(width: TSizes.spaceBtwItems,),

        ///reviews
        Row(
          children: [
            const TRatingBarIndicator(rating: 4.5),
            const SizedBox(width: TSizes.spaceBtwItems,),
            Text('23,April,2024',style: Theme.of(context).textTheme.bodyMedium,)
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems,),
        const ReadMoreText(
          'Giao diện người dùng của ứng dụng khá trực quan. Tôi đã có thể điều hướng và mua hàng một cách liền mạch. Bạn đã làm rất tốt!',          trimLines: 3,
          trimMode: TrimMode.Line,
          trimExpandedText: 'Ẩn bớt',
          trimCollapsedText: 'Xem thêm',
          moreStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: TColors.primaryColor),
          lessStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: TColors.primaryColor),
        ),
        const SizedBox(height: TSizes.spaceBtwItems,),

        ///company review
        TRoundedContainer(
          backgroundColor: dark ? TColors.darkerGrey : TColors.grey,
          child: Padding(
            padding: const EdgeInsets.all(TSizes.md),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("T's Store",style: Theme.of(context).textTheme.bodyLarge),
                    Text('23,Oct,2024',style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                const ReadMoreText(
                  'Giao diện người dùng của ứng dụng khá trực quan. Tôi đã có thể điều hướng và mua hàng một cách liền mạch. Bạn đã làm rất tốt!',                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimExpandedText: 'Ẩn bớt',
                  trimCollapsedText: 'Xem thêm',
                  moreStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: TColors.primaryColor),
                  lessStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: TColors.primaryColor),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections,),

      ],
    );
  }
}

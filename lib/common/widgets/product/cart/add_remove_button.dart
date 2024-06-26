import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/common/widgets/icon/circular_icon.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class TProductQuantityWithAddRemoveButton extends StatelessWidget {
  const TProductQuantityWithAddRemoveButton({
    super.key, required this.quantity, this.add, this.remove,
  });

  final int quantity;
  final VoidCallback? add, remove;

  @override
  Widget build(BuildContext context) {

    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// remove button
        TCircularIcon(
          icon: Iconsax.minus,
          width: 32,
          height: 32,
          size: TSizes.md,
          color: dark ? TColors.white :  TColors.black,
          backgroundColor: dark ? TColors.darkerGrey : TColors.light,
          onPressed: remove,
        ),

        const SizedBox(width: TSizes.spaceBtwItems,),
        Text(quantity.toString(),style: Theme.of(context).textTheme.titleSmall,),
        const SizedBox(width: TSizes.spaceBtwItems,),

        /// add button
         TCircularIcon(
          icon: Iconsax.add,
          width: 32,
          height: 32,
          size: TSizes.md,
          color:TColors.white,
          backgroundColor: TColors.primaryColor,
          onPressed: add,
        ),
      ],
    );
  }
}

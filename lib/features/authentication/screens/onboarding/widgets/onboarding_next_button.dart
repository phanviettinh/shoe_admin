import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/features/authentication/controllers/onbroading/onboarding_controller.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/device/device_utility.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark  = THelperFunctions.isDarkMode(context);
    return Positioned(
        right: TSizes.defaultSpace,
        bottom: TDeviceUtils.getBottomNavigationBarHeight(),
        child: ElevatedButton(
          onPressed: () => OnBoardingController.instance.nextPage(),
          style: ElevatedButton.styleFrom(shape: const CircleBorder(),backgroundColor: dark ? TColors.primaryColor : Colors.black),
          child: const Icon(Iconsax.arrow_right_3),
        ));
  }
}


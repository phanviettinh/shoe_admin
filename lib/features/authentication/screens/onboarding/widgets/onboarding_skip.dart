
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/admin/login/login_admin_screen.dart';
import 'package:shoe_admin/features/authentication/screens/login/login.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/device/device_utility.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: TDeviceUtils.getAppBarHeight(),
        right: TSizes.spaceBtwItems,
        child: TextButton(
          onPressed: () => Get.offAll(() => const LoginAdminScreen()),
          child: const Text('Skip'),
        ));
  }
}
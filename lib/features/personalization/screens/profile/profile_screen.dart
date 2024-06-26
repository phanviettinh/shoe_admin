import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/images/circular_image.dart';
import 'package:shoe_admin/common/widgets/shimmer/shimmer.dart';
import 'package:shoe_admin/common/widgets/text/section_heading.dart';
import 'package:shoe_admin/features/personalization/controllers/user_controller.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';

import 'widgets/change_name.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      appBar: const TAppbar(
        showBackArrow: true,
        title: Text('Profile'),
      ),

      ///body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///profile picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      final image = networkImage.isNotEmpty ? networkImage : TImages.user;
                      return controller.imageUploading.value
                          ? const TShimmerEffect(width: 80,height: 80,radius: 80,)
                          : TCircularImage(image: image,width: 80,height: 80,fit: BoxFit.cover,isNetworkImage: networkImage.isNotEmpty,);
                    }),
                    TextButton(onPressed: () => controller.uploadUserProfilePicture(), child: const Text('Change Profile Picture')),
                  ],
                ),
              ),

              ///detail
              const SizedBox(height: TSizes.spaceBtwItems / 2 ,),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              ///heading profile info
              const TSectionHeading(title: 'Profile Information',showActionButton: false,),
              const SizedBox(height: TSizes.spaceBtwItems),

               TProfileMenu(onPressed: () => Get.to(() => const ChangeName()), title: 'Name', value: controller.user.value.fullName,),
               TProfileMenu(onPressed: () {  }, title: 'Username', value: controller.user.value.username,),

              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              ///heading personal info
              const TSectionHeading(title: 'Personal Information',showActionButton: false,),
              const SizedBox(height: TSizes.spaceBtwItems),

              TProfileMenu(onPressed: () {  }, title: 'User ID', value: controller.user.value.id,icon: Iconsax.copy,),
              TProfileMenu(onPressed: () {  }, title: 'E-mail', value: controller.user.value.email,),
              TProfileMenu(onPressed: () {  }, title: 'Phone Number', value: controller.user.value.phoneNumber,),
              TProfileMenu(onPressed: () {  }, title: 'Gender', value: 'Male',),
              TProfileMenu(onPressed: () {  }, title: 'Date of Birth', value: 'April 15, 2002',),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: const Text('Close Account', style: TextStyle(color: Colors.red),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


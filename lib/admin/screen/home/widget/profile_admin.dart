import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/common/widgets/images/circular_image.dart';
import 'package:shoe_admin/common/widgets/shimmer/shimmer.dart';
import 'package:shoe_admin/common/widgets/text/section_heading.dart';
import 'package:shoe_admin/features/personalization/controllers/user_controller.dart';
import 'package:shoe_admin/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';


class ProfileAdmin extends StatelessWidget {
  const ProfileAdmin({
    super.key,
    required this.controller,
  });

  final UserController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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


          ],
        ),

    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/admin/login/widget/login_form_admin.dart';
import 'package:shoe_admin/common/styles/spacing_styles.dart';
import 'package:shoe_admin/common/widgets/login_signup/form_divider.dart';
import 'package:shoe_admin/features/authentication/screens/login/login.dart';
import 'package:shoe_admin/features/authentication/screens/login/widgets/login_form.dart';
import 'package:shoe_admin/features/authentication/screens/login/widgets/login_header.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/constants/text_strings.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class LoginAdminScreen extends StatelessWidget {
  const LoginAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return  Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              ///logo and subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    height: 150,

                    image: AssetImage(
                        dark ? TImages.lightAppLogo : TImages.darkAppLogo),
                  ),
                  Text(
                    'WelCome Administrator',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: TSizes.sm,
                  ),

                ],
              ),

              ///form
              const TLoginFormAdmin(),


            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/admin/signup/widget/signup_form_admin.dart';
import 'package:shoe_admin/common/widgets/login_signup/form_divider.dart';
import 'package:shoe_admin/common/widgets/login_signup/social_button.dart';
import 'package:shoe_admin/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/constants/text_strings.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';


class SignupScreenAdmin extends StatelessWidget {
  const SignupScreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left,color: THelperFunctions.isDarkMode(context) ? TColors.white : TColors.dark,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///title
              Text(TTexts.signupTitle,style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: TSizes.spaceBtwSections,),

              ///form Signup
              const TSignupFormAdmin(),

            ],
          ),
        ),
      ),
    );
  }
}


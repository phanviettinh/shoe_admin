import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/admin/login/login_admin_screen.dart';
import 'package:shoe_admin/features/authentication/controllers/forget_password/forget_passwrod_controller.dart';
import 'package:shoe_admin/features/authentication/screens/login/login.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/constants/text_strings.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';
import 'package:shoe_admin/utils/validators/validation.dart';


class ForgetPasswordAdmin extends StatelessWidget {
  const ForgetPasswordAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left,color: THelperFunctions.isDarkMode(context) ? TColors.white : TColors.dark,),
          onPressed: () => Get.offAll(() => const LoginAdminScreen()),
        ),
      ),      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///headings
            Text(
              TTexts.forgetPassword,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: TSizes.spaceBtwItems,),
            Text(
              TTexts.forgetPasswordSubTitle,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: TSizes.spaceBtwSections,),

            ///Text field
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: TValidator.validateEmail,
                decoration: const InputDecoration(labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct_right)
            ),
            ),),
            const SizedBox(height: TSizes.spaceBtwSections,),

            ///submit button
            SizedBox(width: double.infinity,child: ElevatedButton(onPressed: () => controller.sendPasswordResetEmail(), child: const Text(TTexts.submit))
              ,)
          ],
        ),
      ),
    );
  }
}

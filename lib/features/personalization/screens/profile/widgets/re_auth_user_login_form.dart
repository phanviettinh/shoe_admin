import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/features/personalization/controllers/user_controller.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/constants/text_strings.dart';
import 'package:shoe_admin/utils/validators/validation.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: const TAppbar(showBackArrow: true,title: Text('Re-Authenticate User'),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: controller.reAuthFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///email
                TextFormField(
                  controller: controller.verifyEmail,
                  validator: TValidator.validateEmail,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.direct_right),labelText: TTexts.email),
                ),
                const SizedBox(height: TSizes.spaceBtwInoutFields,),
                
                ///verify password
                Obx(() => TextFormField(
                  obscureText: controller.hidePassword.value,
                  controller: controller.verifyPassword,
                  validator: (value) => TValidator.validateEmptyText('Password', value),
                  decoration:  InputDecoration(
                      prefixIcon: const Icon(Iconsax.password_check),
                      labelText: TTexts.password,
                      suffixIcon: IconButton(
                          onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                          icon:  Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye)
                      )
                  ),

                ),),
                const SizedBox(height: TSizes.spaceBtwSections,),

                ///login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () => controller.reAuthenticateEmailAndPasswordUser(),child: const Text('Verify'),),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

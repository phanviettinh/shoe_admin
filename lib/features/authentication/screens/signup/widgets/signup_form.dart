import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/features/authentication/controllers/signup/signup_controller.dart';
import 'package:shoe_admin/features/authentication/screens/signup/verify_email.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/constants/text_strings.dart';
import 'package:shoe_admin/utils/validators/validation.dart';

import 'team_of_the_conditions.dart';

class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
        key: controller.signupFormKey,
        child: Column(
          children: [
            Row(
              children: [
                ///first name
                Expanded(
                  child: TextFormField(
                    controller: controller.firstName,
                    validator: (value) =>
                        TValidator.validateEmptyText('First name', value),
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: TTexts.firstName,
                        prefixIcon: Icon(Iconsax.user)),
                  ),
                ),

                const SizedBox(
                  width: TSizes.spaceBtwInoutFields,
                ),

                ///last name
                Expanded(
                  child: TextFormField(
                    controller: controller.lastName,
                    validator: (value) =>
                        TValidator.validateEmptyText('Last name', value),
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: TTexts.lastName,
                        prefixIcon: Icon(Iconsax.user)),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: TSizes.spaceBtwInoutFields,
            ),

            ///user name
            TextFormField(
              controller: controller.userName,
              validator: (value) =>
                  TValidator.validateEmptyText('Username', value),
              expands: false,
              decoration: const InputDecoration(
                  labelText: TTexts.username,
                  prefixIcon: Icon(Iconsax.user_edit)),
            ),

            const SizedBox(
              height: TSizes.spaceBtwInoutFields,
            ),

            ///email
            TextFormField(
              controller: controller.email,
              validator: (value) => TValidator.validateEmail(value),
              expands: false,
              decoration: const InputDecoration(
                  labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct)),
            ),

            const SizedBox(
              height: TSizes.spaceBtwInoutFields,
            ),

            ///phone number
            TextFormField(
              controller: controller.phoneNumber,
              validator: (value) => TValidator.validatePhoneNumber(value),
              expands: false,
              decoration: const InputDecoration(
                  labelText: TTexts.phone, prefixIcon: Icon(Iconsax.call)),
            ),

            const SizedBox(
              height: TSizes.spaceBtwInoutFields,
            ),
            ///Role
            SizedBox(
              height: 0,
              width: 0,
              child: TextFormField(
                controller: controller.role,
              ),
            ),

            ///password
            Obx(() => TextFormField(
              controller: controller.password,
              validator: (value) => TValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              expands: false,
              decoration:  InputDecoration(
                  labelText: TTexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                      icon:  Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye))),
            )),

            const SizedBox(
              height: TSizes.spaceBtwInoutFields,
            ),

            ///term&conditions checkbox
            const TTermOfTheConditions(),

            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),

            ///sign up button

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.signup(),
                child: const Text(TTexts.createAccount),
              ),
            )
          ],
        ));
  }
}

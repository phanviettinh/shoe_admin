import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shoe_admin/common/styles/spacing_styles.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/constants/text_strings.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.subtitle,
      required this.onPressed});

  final String image, title, subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
              ///image
                Lottie.asset(image,width: MediaQuery.of(context).size.width * 0.6),

              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              ///title & subtitle
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              ///button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: const Text(TTexts.continues),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/features/shop/controllers/banner_controller.dart';
import 'package:shoe_admin/features/shop/models/banner_model.dart';
import 'package:shoe_admin/features/shop/models/brand_model.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';

class AddBanner extends StatelessWidget {
  const AddBanner({super.key, this.banner});

  final BannerModel? banner;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());

    if (banner != null) {
      controller.setBannerData(banner!);
    } else {
      controller.resetBannerData();
    }

    return Scaffold(
      appBar: TAppbar(
        title: banner == null ? const Text('Add Banners') : const Text('Update Banner'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.pickAndUploadImage(),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: controller.image,
                        decoration: const InputDecoration(labelText: 'Image URL'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.targetScreen.text.isEmpty
                    ? null
                    : controller.targetScreen.text,
                decoration: const InputDecoration(labelText: 'Target Screen'),
                items: controller.targetScreenOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    controller.targetScreen.text = newValue;
                  }
                },
              );
            }),
            const SizedBox(height: TSizes.spaceBtwItems),
            Obx(() => Column(
              children: [
                const Text('Show UI'),
                Switch(
                  value: controller.active.value,
                  onChanged: (value) => controller.active.value = value,
                ),
              ],
            )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {

                  if (banner != null) {
                    await controller.updateCurrentBanner();
                  } else {
                    await controller.saveBanner();
                    controller.resetBannerData();

                  }
                },
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

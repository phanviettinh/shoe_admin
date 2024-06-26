import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/features/shop/controllers/brand_controller.dart';
import 'package:shoe_admin/features/shop/models/brand_model.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class AddBrandsAdmin extends StatelessWidget {
  const AddBrandsAdmin({super.key, this.brand});

  final BrandModel? brand;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());
    final dark = THelperFunctions.isDarkMode(context);

    if (brand != null) {
      controller.setBrandData(brand!);
    } else {
      controller.resetBrandData();
    }

    return Scaffold(
      appBar: TAppbar(
        title: brand == null
            ? const Text('Add Brands')
            : const Text('Update Brands'),
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ///image
                          Obx(() => Row(
                                children: [
                                  const Text('Choose image Brand: '),
                                  const SizedBox(
                                    width: TSizes.spaceBtwSections,
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        controller.pickAndUploadImage(),
                                    child: controller.imageUrl.value.isNotEmpty
                                        ? Image.network(
                                            controller.imageUrl.value,
                                            height: 100,
                                            width: 100)
                                        : Container(
                                            height: 100,
                                            width: 100,
                                            color: dark
                                                ? TColors.dark
                                                : TColors.white,
                                            child: const Icon(Icons.add),
                                          ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            Offstage(
              offstage: true, // Đặt thành false để hiển thị
              child: TextField(
                controller: controller.textIdController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            Obx(() => Column(
                  children: [
                    const Text('Show UI'),
                    Switch(
                      value: controller.isFeatured.value,
                      onChanged: (value) => controller.isFeatured.value = value,
                    ),
                  ],
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final brand = this.brand;
          if (brand != null) {
            await controller.updateBrandData(brand); // Hàm update sản phẩm
          } else {
            await controller.saveBrand(); // Hàm lưu sản phẩm mới
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

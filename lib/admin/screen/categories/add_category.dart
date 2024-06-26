import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/features/shop/controllers/category_controller.dart';
import 'package:shoe_admin/features/shop/models/category_model.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

import '../../../common/widgets/appbar/appbar.dart';

class AddCategory extends StatelessWidget {
  const AddCategory({super.key, this.category});

  final CategoryModel? category;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    final dark = THelperFunctions.isDarkMode(context);

    if (category != null) {
      controller.setCategoryData(category!);
    } else {
      controller.resetCategoryData();
    }

    return Scaffold(
      appBar: TAppbar(
        title: category == null
            ? const Text('Add Categories')
            : const Text('Update Categories'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Row(
                  children: [
                    const Text('Choose image Category: '),
                    const SizedBox(
                      width: TSizes.spaceBtwSections,
                    ),
                    GestureDetector(
                      onTap: () => controller.pickAndUploadImage(),
                      child: controller.imageUrl.value.isNotEmpty
                          ? Image.network(controller.imageUrl.value,
                              height: 100, width: 100)
                          : Container(
                              height: 100,
                              width: 100,
                              color: dark ? TColors.dark : TColors.white,
                              child: const Icon(Icons.add),
                            ),
                    )
                  ],
                )),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            TextField(
              controller: controller.name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            TextField(
              controller: controller.parentId,
              decoration: const InputDecoration(labelText: 'Category'),
              onTap: () => controller.showCategoryPickerDialog(context),
              readOnly: true,
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
          final category = this.category;
          if (category != null) {
            await controller
                .updateCategoryData(category); // Hàm update sản phẩm
          } else {
            await controller.saveCategory(); // Hàm lưu sản phẩm mới
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

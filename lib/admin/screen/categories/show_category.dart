import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/admin/screen/categories/add_category.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/common/widgets/icon/circular_icon.dart';
import 'package:shoe_admin/common/widgets/images/rounded_image.dart';
import 'package:shoe_admin/common/widgets/text/section_heading2.dart';
import 'package:shoe_admin/features/shop/controllers/category_controller.dart';
import 'package:shoe_admin/features/shop/screens/home/widgets/home_category.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';

import '../../../common/widgets/appbar/appbar.dart';

class ShowCategory extends StatelessWidget {
  const ShowCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    return  Scaffold(
      appBar: TAppbar(
        title: const Text('Categories'),
        showBackArrow: true,
          actions: [
            TCircularIcon(icon: Iconsax.add,onPressed: () => Get.to(() =>  const AddCategory()))
          ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Searchbar
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                controller.filterCategory(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.filteredCategories.isEmpty) {
                  return const Center(child: Text('No Data Found!'));
                }

                return ListView.builder(
                  itemCount: controller.filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = controller.filteredCategories[index];
                    return Slidable(
                      key: ValueKey(category.id),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Get.to(() => AddCategory(category: category));
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Update',
                          ),
                          SlidableAction(
                            onPressed: (context) async {
                              // Xác nhận xóa
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: const Text(
                                          'Are you sure you want to delete this category?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                              );

                              if (confirmed == true) {
                                await controller.deleteCategory(category.id);
                              }
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                        child: Row(
                          children: [
                            TRoundedContainer(
                              width: 50,
                              height: 50,
                              backgroundColor: Colors.grey[200]!,
                              child: TRoundedImage(
                                imageUrl: category.image,
                                isNetworkImage: true,
                              ),
                            ),
                            const SizedBox(width: TSizes.spaceBtwItems,),
                            Text(
                              category.name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const Spacer(),
                            Icon(Icons.notifications_active,color: category.isFeatured ? Colors.blue : Colors.red,),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

          ],
        ),
      ),
    );
  }
}

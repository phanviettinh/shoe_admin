import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/admin/screen/brands/add_brands_admin.dart';
import 'package:shoe_admin/admin/screen/brands/update_delete_brand.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/brands/brand_card.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/common/widgets/icon/circular_icon.dart';
import 'package:shoe_admin/common/widgets/images/rounded_image.dart';
import 'package:shoe_admin/common/widgets/layouts/grid_layout.dart';
import 'package:shoe_admin/common/widgets/shimmer/brands_shimmer.dart';
import 'package:shoe_admin/common/widgets/text/section_heading.dart';
import 'package:shoe_admin/features/shop/controllers/brand_controller.dart';
import 'package:shoe_admin/features/shop/models/brand_model.dart';
import 'package:shoe_admin/features/shop/screens/brands/brand_products.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';


class ShowBrandAdmin extends StatelessWidget {
  const ShowBrandAdmin({super.key, this.brand});

  final BrandModel? brand;

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;

    return Scaffold(
      appBar:  TAppbar(
          title: const Text('Brands'),
          showBackArrow: true,
          actions: [
            TCircularIcon(icon: Iconsax.add,onPressed: () => Get.to(() =>  const AddBrandsAdmin()))
          ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Searchbar
            TextField(
              controller: brandController.searchController,
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                brandController.filterBrand(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (brandController.filteredBrands.isEmpty) {
                  return const Center(child: Text('No Data Found!'));
                }

                return ListView.builder(
                  itemCount: brandController.filteredBrands.length,
                  itemBuilder: (context, index) {
                    final brand = brandController.filteredBrands[index];
                    return Slidable(
                      key: ValueKey(brand.id),
                      // Sử dụng `imageUrl` làm khóa
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Get.to(() => AddBrandsAdmin(brand: brand));
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
                                          'Are you sure you want to delete this brand?'),
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

                                await brandController.deleteBrand(brand.id);
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
                                imageUrl: brand.image,
                                isNetworkImage: true,
                              ),
                            ),
                            const SizedBox(width: TSizes.spaceBtwItems,),
                            Text(
                              brand.name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const Spacer(),
                            Icon(Icons.notifications_active,color: brand.isFeatured! ? Colors.blue : Colors.red,),
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

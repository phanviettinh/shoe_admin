import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/admin/screen/banners/add_banners_admin.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/common/widgets/icon/circular_icon.dart';
import 'package:shoe_admin/common/widgets/images/rounded_image.dart';
import 'package:shoe_admin/features/shop/controllers/banner_controller.dart';
import 'package:shoe_admin/features/shop/models/banner_model.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';


class ShowBannerAdmin extends StatelessWidget {
  const ShowBannerAdmin({super.key, this.banner});

  final BannerModel? banner;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());

    return Scaffold(
      appBar: TAppbar(
        title: const Text('Banners'),
        showBackArrow: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => const AddBanner());
            },
          ),
        ],
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
                controller.filterBanner(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.filteredBanners.isEmpty) {
                  return const Center(child: Text('No Data Found!'));
                }

                return ListView.builder(
                  itemCount: controller.filteredBanners.length,
                  itemBuilder: (context, index) {
                    final banner = controller.filteredBanners[index];
                    return Slidable(
                      key: ValueKey(banner.imageUrl),
                      // Sử dụng `imageUrl` làm khóa
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Get.to(() => AddBanner(banner: banner));
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
                                          'Are you sure you want to delete this banner?'),
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

                                await controller.deleteCurrentBanner();
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
                                imageUrl: banner.imageUrl,
                                isNetworkImage: true,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              banner.targetScreen,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const Spacer(),
                            Icon(Icons.notifications_active,color: banner.active ? Colors.blue : Colors.red,),
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
  }}
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/admin/screen/customers/customer_detail.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/common/widgets/images/rounded_image.dart';
import 'package:shoe_admin/features/authentication/models/user_model.dart';
import 'package:shoe_admin/features/personalization/controllers/user_controller.dart';
import 'package:shoe_admin/features/shop/controllers/product/order_controller.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class ShowCustomer extends StatelessWidget {
  const ShowCustomer({super.key, this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(UserController());
    final orderController = Get.put(OrderController());

    return Scaffold(
      appBar: const TAppbar(
        title: Text('Customers'),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
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
                controller.filterUser(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.filteredUsers.isEmpty) {
                  return const Center(child: Text('No Data Found!'));
                }

                // Lọc những người dùng có role là 'Client'
                final clients = controller.filteredUsers
                    .where((user) => user.role == 'Client')
                    .toList();

                return  ListView.builder(
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final user = clients[index];

                    //
                    final orderCount = orderController.countOrdersForUser(user.id);

                    return GestureDetector(
                        onTap: () => Get.to((CustomerDetail(
                      user: user,
                    ))),
                    child: Slidable(
                      key: ValueKey(user.id),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              // Get.to(() => AddUser(user: user));
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Update',
                          ),
                          SlidableAction(
                            onPressed: (context) async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: const Text(
                                      'Are you sure you want to delete this customer?'),
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
                                await controller.deleteUser(user.id);
                              }
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child:  Padding(
                          padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                          child: Row(
                            children: [
                              TRoundedContainer(
                                width: 50,
                                height: 50,
                                backgroundColor:
                                    dark ? TColors.grey : TColors.light,
                                child: TRoundedImage(
                                  imageUrl: user.profilePicture,
                                  isNetworkImage: true,
                                ),
                              ),
                              const SizedBox(width: TSizes.spaceBtwItems),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.username,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  const SizedBox(height: TSizes.spaceBtwItems),
                                   Text(
                                      '$orderCount Orders',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.green),

                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                    )
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

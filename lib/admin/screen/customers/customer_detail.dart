import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/admin/screen/orders/widgets/order_detail.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/common/widgets/loaders/animation_loader.dart';
import 'package:shoe_admin/features/authentication/models/user_model.dart';
import 'package:shoe_admin/features/shop/controllers/product/order_controller.dart';
import 'package:shoe_admin/features/shop/models/order_model.dart';
import 'package:shoe_admin/navigation_menu.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/cloud_helper_function.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class CustomerDetail extends StatelessWidget {
  const CustomerDetail({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final orderController = Get.put(OrderController());
    final orderCount = orderController.countOrdersForUser(user.id);

    return Scaffold(
      appBar: TAppbar(
        title: Text(user.username),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First name: ${user.firstName}'),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text('Last name: ${user.lastName}'),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text('Phone number: ${user.phoneNumber}'),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text('Email: ${user.email}'),
            const SizedBox(height: TSizes.spaceBtwSections),
            Text(
              '$orderCount Orders',
              style: const TextStyle(fontSize: 12, color: Colors.green),
            ),
            const SizedBox(height: TSizes.spaceBtwItems,),
            Expanded(  // Thêm Expanded ở đây
              child: FutureBuilder<List<OrderModel>>(
                future: orderController.fetUserOrdersClient(user.id),
                builder: (_, snapshot) {
                  final response = TCloudHelperFunctions.checkMultiRecordState(
                    snapshot: snapshot,
                  );
                  if (response != null) return response;

                  // Chuyển đổi dữ liệu đơn hàng
                  final orders = snapshot.data ?? [];

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems),
                    separatorBuilder: (_, __) => const SizedBox(
                      height: TSizes.spaceBtwItems / 3,
                    ),
                    itemCount: orders.length,
                    itemBuilder: (_, index) {
                      final order = orders[index];

                      return Slidable(
                        key: ValueKey(order.id),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirm Deletion'),
                                    content: const Text(
                                        'Are you sure you want to delete this order?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed == true) {
                                  await orderController.deleteOrder2(user.id,orderId: order.id);
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
                          padding: const EdgeInsets.all(TSizes.spaceBtwItems / 2),
                          child: GestureDetector(
                            onTap: () => Get.to(
                                  () => OrderDetailAdmin(order: order, user: user),
                            ),
                            child: TRoundedContainer(
                              showBorder: true,
                              backgroundColor: dark ? TColors.dark : TColors.light,
                              padding: const EdgeInsets.all(TSizes.md),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.id,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      const Spacer(),
                                      Text(
                                        order.formattedOrderDate,
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: TSizes.spaceBtwItems),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.orderStatusText,
                                        style: Theme.of(context).textTheme.bodyLarge!.apply(
                                          color: order.orderStatusText == 'Processing'
                                              ? TColors.primaryColor
                                              : order.orderStatusText == 'Shipping'
                                              ? Colors.yellow
                                              : order.orderStatusText == 'Received'
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeightDelta: 1,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '\$${order.totalAmount.toStringAsFixed(1)}',
                                        style: const TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

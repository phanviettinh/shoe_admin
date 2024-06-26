import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shoe_admin/admin/screen/orders/widgets/order_detail.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/features/authentication/models/user_model.dart';
import 'package:shoe_admin/features/shop/controllers/product/order_controller.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class OrderProceeds extends StatelessWidget {
  const OrderProceeds({super.key, this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final orderController = Get.put(OrderController());

    // Nhận ngày từ đối số được truyền qua

    // Lọc các đơn hàng theo ngày đã chọn
    orderController.filterOrdersByDate();

    return Scaffold(
      appBar: const TAppbar(
        title: Text('Orders'),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Searchbar
            Expanded(
              child: Obx(() {
                if (orderController.filteredOrders.isEmpty) {
                  return const Center(child: Text('No Data Found!'));
                }

                return ListView.builder(
                  itemCount: orderController.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = orderController.filteredOrders[index];
                    final user = orderController.getUserById(order.userId);

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
                                  content: const Text('Are you sure you want to delete this order?'),
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
                                await orderController.deleteOrder(user!.id, order.id);
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
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => Get.to(() => OrderDetailAdmin(order: order, user: user!)),
                          child: TRoundedContainer(
                            showBorder: true,
                            backgroundColor: dark ? TColors.dark : TColors.light,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(order.id, style: Theme.of(context).textTheme.titleMedium),
                                    const Spacer(),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(order.orderDate),
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
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
              }),
            ),
          ],
        ),
      ),
    );
  }
}

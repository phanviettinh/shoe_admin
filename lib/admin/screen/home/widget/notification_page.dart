import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/features/shop/controllers/product/order_controller.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Orders'),
      ),
      body: Obx(() {
        if (orderController.newOrders.isEmpty) {
          return const Center(child: Text('No new orders.'));
        } else {
          return ListView.builder(
            itemCount: orderController.newOrders.length,
            itemBuilder: (context, index) {
              final order = orderController.newOrders[index];
              return ListTile(
                title: Text('Order ID: ${order.id}'),
                subtitle: Text('Total: \$${order.totalAmount}'),
                onTap: () {
                  // Xử lý khi người dùng nhấn vào một đơn hàng
                },
              );
            },
          );
        }
      }),
    );
  }
}

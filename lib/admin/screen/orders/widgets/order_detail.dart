import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shoe_admin/admin/screen/customers/customer_detail.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/data/repositories/users/user_repository.dart';
import 'package:shoe_admin/features/authentication/models/user_model.dart';
import 'package:shoe_admin/features/shop/controllers/product/cart_controller.dart';
import 'package:shoe_admin/features/shop/controllers/product/order_controller.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/enums.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';
import 'package:shoe_admin/utils/helpers/pricing_caculator.dart';

import '../../../../features/personalization/controllers/user_controller.dart';
import '../../../../features/shop/models/order_model.dart';

class OrderDetailAdmin extends StatelessWidget {
   OrderDetailAdmin({super.key, required this.order, required this.user});

  final OrderModel order;
  final UserModel user;
  final TextEditingController orderDateController = TextEditingController();
  final TextEditingController deliveryDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final cartController = CartController.instance;
    final subTotal = cartController.totalCartPrice.value;
    final totalAmount = TPricingCalculator.calculateTotalPrice(subTotal, 'US');
    final orderController = Get.put(OrderController());
    orderDateController.text = DateFormat('yyyy-MM-dd').format(order.orderDate);
    deliveryDateController.text = DateFormat('yyyy-MM-dd').format(order.deliveryDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders detail'),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back,color: dark ? TColors.white : TColors.dark,),
          onPressed: () async {
            // Gọi phương thức fetch lại dữ liệu khi ấn nút back
            await orderController.fetchAllUserOrders();
            Get.back(result: true);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: order.orderStatusText,
                onChanged: (newValue) {
                  // Cập nhật trạng thái đơn hàng
                  order.orderStatusText == newValue;

                  // Tùy vào giá trị newValue, gọi các hàm cập nhật trạng thái từ orderController tương ứng
                  switch (newValue) {
                    case 'Processing':
                      orderController.processOrderAdmin(user.id,totalAmount,orderId: order.id);
                      break;
                    case 'Shipping':
                      orderController.shippedOrder(user.id, totalAmount,orderId: order.id);
                      break;
                    case 'Received':
                      orderController.receivedOrderAdmin(user.id, totalAmount,orderId: order.id);
                      break;
                    case 'Cancelled':
                      orderController.cancelledOrderAdmin(user.id, totalAmount,orderId: order.id);
                      break;
                    default:
                    // Xử lý trường hợp mặc định nếu cần
                      break;
                  }
                },
                items: orderController.orderStatusOptions.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(
                      status,
                      style: TextStyle(
                        color: status == 'Processing'
                            ? TColors.primaryColor
                            : status == 'Shipping'
                            ? Colors.yellow
                            : status == 'Received'
                            ? Colors.green
                            : Colors
                            .red, // Default color if no conditions match
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              ///order date
              // Order Date
              TextFormField(
                controller: orderDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Order Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: order.orderDate,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        orderDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                        DateTime newOrderDate = DateFormat('yyyy-MM-dd').parse(orderDateController.text);
                        orderController.updateOrderDates(user.id, newOrderDate, order.orderDate);
                      }
                    },
                  ),
                ),
              ),              const SizedBox(height: TSizes.spaceBtwItems),
              ///delivery date
              TextFormField(
                controller: deliveryDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Delivery Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: order.deliveryDate,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        deliveryDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                        DateTime newOrderDate = DateFormat('yyyy-MM-dd').parse(deliveryDateController.text);
                        orderController.updateDeliveryDates(user.id, newOrderDate, order.deliveryDate);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
             ///name client
             Row(
               children: [
                 const Text(
                   'Name Client: ',
                 ),
                 const SizedBox(width: TSizes.spaceBtwItems / 2,),
                 GestureDetector(
                   onTap: () => Get.to(( CustomerDetail(user: user,))),
                   child: Text(user.fullName,style: const TextStyle(color: Colors.green),),
                 )
               ],
             ),
              const SizedBox(height: TSizes.spaceBtwItems),
              ///payment
              Text(
                'Payment method: ${order.paymentMethod}',
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              ///date of payment
              if(order.status == OrderStatus.received)
              Row(
                children: [
                  const Text(
                    'Date of payment: ',
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text(order.searchDate.toString(), style: TextStyle(fontSize: 12),),
                ],
              ),
              if(order.status == OrderStatus.received)
                const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                'Address: ${order.address.toString()}',
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              const Text(
                'Items order:',
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: order.items.map((item) {
                  return ListTile(
                    leading: item.image != null
                        ? Image.network(item.image!)
                        : const Placeholder(),
                    title: Text(item.title),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(1)}'),
                  );
                }).toList(),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              const Divider(),
              const SizedBox(height: 8),

              ///Shipping Fee
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shipping Fee',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '+ \$${TPricingCalculator.calculateShippingCost(subTotal, 'US')}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems / 2,
              ),

              ///Tax Fee
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tax Fee',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '+ \$${TPricingCalculator.calculateTax(subTotal, 'US')}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems / 2,
              ),

              ///Order Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Total',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '\$${order.totalAmount.toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

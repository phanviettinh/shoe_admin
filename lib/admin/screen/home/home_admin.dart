import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/admin/screen/banners/show_banners_admin.dart';
import 'package:shoe_admin/admin/screen/brands/show_brands_admin.dart';
import 'package:shoe_admin/admin/screen/categories/show_category.dart';
import 'package:shoe_admin/admin/screen/customers/show_customer.dart';
import 'package:shoe_admin/admin/screen/home/widget/notification_page.dart';
import 'package:shoe_admin/admin/screen/orders/order_admin.dart';
import 'package:shoe_admin/admin/screen/products/show_product_admin.dart';
import 'package:shoe_admin/admin/signup/signup_admin.dart';
import 'package:shoe_admin/common/widgets/shimmer/shimmer.dart';
import 'package:shoe_admin/data/repositories/authentication/authentication_repository.dart';
import 'package:shoe_admin/features/personalization/controllers/user_controller.dart';
import 'package:shoe_admin/features/personalization/screens/profile/profile_screen.dart';
import 'package:shoe_admin/features/shop/controllers/product/order_controller.dart';
import 'package:shoe_admin/features/shop/controllers/product/product_controller.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/constants/text_strings.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

import '../../features/firebaseNotification.dart';
import 'widget/home_proceeds.dart';
import 'widget/profile_admin.dart';

class HomeScreenAdmin extends StatelessWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final userController = Get.put(UserController());
    final productController = Get.put(ProductController());
    final orderController = Get.put(OrderController());

    // Thiết lập lắng nghe Firebase Messaging
// Thiết lập lắng nghe Firebase Messaging

    // Thiết lập lắng nghe Firebase Messaging
    FirebaseNotificationService().setupFirebase((RemoteMessage message) {
      if (message.data['type'] == 'new_order') {
        orderController.setNewOrderNotification(true);
      }
    });

    return Scaffold(
      backgroundColor: dark ? TColors.black : TColors.light,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Home'),
            const Spacer(),
            Obx(() => Stack(
              children: [
                IconButton(
                  icon: const Icon(Iconsax.notification),
                  onPressed: () {
                    orderController.setNewOrderNotification(false); // Cập nhật trạng thái không có thông báo đơn hàng mới
                    Get.to(() => const NotificationPage());
                  },
                ),
                if (orderController.newOrders.isNotEmpty)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${orderController.newOrders.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            )),
            const SizedBox(width: TSizes.spaceBtwItems),
            const Icon(Icons.email_outlined),
          ],
        ),
        iconTheme: IconThemeData(color: dark ? Colors.white : Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: ProfileAdmin(controller: userController),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.image),
                  SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text('Loading Images')
                ],
              ),
              onTap: () {
                // Xử lý khi người dùng chọn mục trong menu
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Iconsax.ship),
                  SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text('Orders')
                ],
              ),
              onTap: () => Get.to(() => const OrderAdmin()),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Iconsax.box),
                  SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text('Products')
                ],
              ),
              onTap: () => Get.to(() => ShowProductAdmin(
                title: 'Products',
                futureMethod: productController.fetchAllFeaturedProductsNotIsFeatured(),
              )),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Iconsax.flag),
                  SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text('Brands')
                ],
              ),
              onTap: () => Get.to(() => const ShowBrandAdmin()),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Iconsax.grid_1),
                  SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text('Categories')
                ],
              ),
              onTap: () => Get.to(() => const ShowCategory()),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Iconsax.document),
                  SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text('Banners')
                ],
              ),
              onTap: () => Get.to(() => const ShowBannerAdmin()),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Iconsax.user),
                  SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text('Customers')
                ],
              ),
              onTap: () => Get.to(() => const ShowCustomer()),
            ),
            const Divider(),
            TextButton(
              onPressed: () {
                AuthenticationRepository.instance.logoutAdmin();
                Navigator.pop(context);
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
      body: const HomeProceeds(),
    );
  }
}



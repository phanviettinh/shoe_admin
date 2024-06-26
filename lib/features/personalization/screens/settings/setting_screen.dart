import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:shoe_admin/common/widgets/list_tiles/settings_menu_tiles.dart';
import 'package:shoe_admin/common/widgets/list_tiles/user_profile_title.dart';
import 'package:shoe_admin/common/widgets/text/section_heading.dart';
import 'package:shoe_admin/data/repositories/authentication/authentication_repository.dart';
import 'package:shoe_admin/features/authentication/screens/login/login.dart';
import 'package:shoe_admin/features/personalization/screens/address/address_screen.dart';
import 'package:shoe_admin/features/personalization/screens/profile/profile_screen.dart';
import 'package:shoe_admin/features/shop/screens/cart/cart_screen.dart';
import 'package:shoe_admin/features/shop/screens/order/order.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///header
             TPrimaryHeaderContainer(
                child: Column(
              children: [
                ///appbar
                const TAppbar(
                  title: Text('Account', style: TextStyle(fontSize: 20, color: TColors.white),),),

                ///user profile card
                TUserProfileTile(onPressed:() => Get.to(() => const ProfileScreen()),),
                const SizedBox(height: TSizes.spaceBtwSections,),
              ],
            )),

            ///body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  /// account settings
                  const TSectionHeading(title: 'Account settings', showActionButton: false,),
                  const SizedBox(height: TSizes.spaceBtwItems,),

                   TSettingMenuTiles(icon: Iconsax.safe_home, title: 'My Address', subtitle: 'Set shopping delivery address',onTap: () => Get.to(() => const AddressScreen()),),
                   TSettingMenuTiles(icon: Iconsax.shopping_cart, title: 'My Cart', subtitle: 'Add, remove products and move to checkout',onTap: () => Get.to(() => const CartScreen()),),
                   TSettingMenuTiles(icon: Iconsax.bag_tick, title: 'My Orders', subtitle: 'In-progress and Completed Orders',onTap: () => Get.to(() => const OrderScreen())),
                  const TSettingMenuTiles(icon: Iconsax.bank, title: 'Bank Account', subtitle: 'Withdraw balance to registered bank account',),
                  const TSettingMenuTiles(icon: Iconsax.discount_shape, title: 'My Coupons', subtitle: 'List of all the discounted coupons',),
                  const TSettingMenuTiles(icon: Iconsax.notification, title: 'Notification', subtitle: 'Set any kind of notification message',),
                  const TSettingMenuTiles(icon: Iconsax.security_card, title: 'Account Privacy', subtitle: 'Manage data usage and connected accounts',),

                  ///app settings
                  const SizedBox(height: TSizes.spaceBtwSections,),
                  const TSectionHeading(title: 'App Settings', showActionButton: false,),

                  const SizedBox(height: TSizes.spaceBtwItems,),
                  const TSettingMenuTiles(icon: Iconsax.document_upload, title: 'Load Data', subtitle: 'Upload Data to your Cloud Firebase'),
                  TSettingMenuTiles(icon: Iconsax.location, title: 'Geolocation', subtitle: 'Set recommendation based on location', trailing: Switch(value: true, onChanged: (value) {}),),
                  TSettingMenuTiles(icon: Iconsax.security_user, title: 'Safe Mode', subtitle: 'Search result is safe for all ages', trailing: Switch(value: false, onChanged: (value) {}),),
                  TSettingMenuTiles(icon: Iconsax.image, title: 'HD Image Quality', subtitle: 'Set image quality to be seen', trailing: Switch(value: false, onChanged: (value) {}),),

                  ///logout button
                  const SizedBox(height: TSizes.spaceBtwSections,),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              "Confirm Logout",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                              "Are you sure you want to log out?",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Perform logout action here
                                  AuthenticationRepository.instance.logout();
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: const Text(
                                  "Logout",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Logout'),
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwSections  * 2),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:shoe_admin/features/authentication/controllers/signup/network_manager.dart';
import 'package:shoe_admin/features/personalization/controllers/address_controller.dart';
import 'package:shoe_admin/features/shop/controllers/product/cart_controller.dart';
import 'package:shoe_admin/features/shop/controllers/product/checkout_controller.dart';
import 'package:shoe_admin/features/shop/controllers/product/variation_controller.dart';

class GeneralBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(VariationController());
    Get.put(AddressController());
    Get.put(CheckoutController());

  }

}
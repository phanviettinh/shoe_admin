import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:shoe_admin/features/authentication/screens/onboarding/onboarding.dart';
import 'package:shoe_admin/features/authentication/screens/password/forget_password.dart';
import 'package:shoe_admin/features/authentication/screens/signup/signup.dart';
import 'package:shoe_admin/features/authentication/screens/signup/verify_email.dart';
import 'package:shoe_admin/features/personalization/screens/address/address_screen.dart';
import 'package:shoe_admin/features/personalization/screens/profile/profile_screen.dart';
import 'package:shoe_admin/features/personalization/screens/settings/setting_screen.dart';
import 'package:shoe_admin/features/shop/screens/checkout/checkout.dart';
import 'package:shoe_admin/features/shop/screens/home/home_screen.dart';
import 'package:shoe_admin/features/shop/screens/order/order.dart';
import 'package:shoe_admin/features/shop/screens/product_reviews/product_review.dart';
import 'package:shoe_admin/features/shop/screens/store/store_screen.dart';
import 'package:shoe_admin/features/shop/screens/wishlist/wishlish_screen.dart';

import 'routes.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: TRoutes.home, page: () => const HomeScreen()),
    GetPage(name: TRoutes.store, page: () => const StoreScreen()),
    GetPage(name: TRoutes.favourites, page: () => const WishList()),
    GetPage(name: TRoutes.settings, page: () => const SettingScreen()),
    GetPage(name: TRoutes.productReviews, page: () => const ProductReview()),
    GetPage(name: TRoutes.order, page: () => const OrderScreen()),
    GetPage(name: TRoutes.checkout, page: () => const CheckoutScreen()),
    GetPage(name: TRoutes.userProfile, page: () => const ProfileScreen()),
    GetPage(name: TRoutes.userAddress, page: () => const AddressScreen()),
    GetPage(name: TRoutes.signup, page: () => const SignupScreen()),
    GetPage(name: TRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: TRoutes.forgetPassWord, page: () => const ForgetPassword()),
    GetPage(name: TRoutes.onBoarding, page: () => const OnBoardingScreen()),
  ];
}
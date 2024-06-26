import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/bindings/genaral_bindings.dart';
import 'package:shoe_admin/features/shop/controllers/all_product_controller.dart';
import 'package:shoe_admin/features/shop/controllers/brand_controller.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/theme/theme.dart';

import 'features/shop/controllers/category_controller.dart';
import 'features/shop/controllers/product/cart_controller.dart';
import 'routes/app_route.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CategoryController());
    Get.put(BrandController());
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBinding(),
      getPages: AppRoutes.pages,
      home: const Scaffold(backgroundColor: TColors.primaryColor,body: Center(child: CircularProgressIndicator(color: TColors.white,),),),
      debugShowCheckedModeBanner: false,
    );
  }
}

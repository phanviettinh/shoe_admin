import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/appbar/tabbar.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:shoe_admin/common/widgets/layouts/grid_layout.dart';
import 'package:shoe_admin/common/widgets/brands/brand_card.dart';
import 'package:shoe_admin/common/widgets/product/cart/cart_menu_icon.dart';
import 'package:shoe_admin/common/widgets/shimmer/brands_shimmer.dart';
import 'package:shoe_admin/common/widgets/text/section_heading.dart';
import 'package:shoe_admin/features/shop/controllers/brand_controller.dart';
import 'package:shoe_admin/features/shop/controllers/category_controller.dart';
import 'package:shoe_admin/features/shop/screens/brands/all_brands.dart';
import 'package:shoe_admin/features/shop/screens/brands/brand_products.dart';
import 'package:shoe_admin/features/shop/screens/store/widgets/category_tab.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final categories = CategoryController.instance.featuredCategories;
    final brandController = Get.put(BrandController());

    return  DefaultTabController(
        length: categories.length,
        child: Scaffold(
          backgroundColor: dark ?  TColors.black : TColors.white,
          appBar: TAppbar(
            title:  Text('Store',style: TextStyle(fontSize: 20,color: dark ? TColors.white :  TColors.dark),),
            actions: [
              TCartCounterIcon( iconColor: dark ?  TColors.white : TColors.dark)
            ],
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_,innerBoxIsScrolled){
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  expandedHeight: 430,

                  flexibleSpace: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children:  [

                        ///search bar
                        const SizedBox(height: TSizes.spaceBtwItems,),
                        const TSearchContainer(text: 'Search in store',showBorder: true,showBackground: false,padding: EdgeInsets.zero,),
                        const SizedBox(height: TSizes.spaceBtwSections,),

                        ///Featured brands
                        TSectionHeading(title: 'Featured Brands',onPressed: () => Get.to(() => const AllBrandScreen()),),
                        const SizedBox(height: TSizes.spaceBtwItems / 1.5,),

                        ///brands grid
                       Obx(() {
                         if(brandController.isLoading.value) return const TBrandShimmer();

                         if(brandController.featuredBrands.isEmpty){
                           return Center(child: Text('No Data Found!',style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),));
                         }else{
                           return  TGridLayout(
                               itemCount: brandController.featuredBrands.length,
                               mainAxisExtent: 80,
                               itemBuilder: (_,index){
                                 final brand = brandController.featuredBrands[index];
                                  return  TBrandCard(
                                    showBorder: false,
                                    brand: brand,
                                    onTap: () => Get.to(() =>  BrandProduct(brand: brand))
                                 );
                           }
                           );
                         }
                       }),
                      ],
                    ),
                  ),

                  ///tab
                  bottom:  TTabBar(tabs: categories.map((category) => Tab(child: Text(category.name))).toList()),
                ),
              ];
            },
            body:  TabBarView(children: categories.map((category) => TCategoryTab(category: category)).toList()),
          ),
        ));
  }
}





import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';

class ImageController extends GetxController{
  static ImageController get instance => Get.find();

  ///variables
 RxString selectedProductImage = ''.obs;

 ///get all image from product and variations
 List<String> getAllProductImages(ProductModel product){

   //use set to add unique images only
   Set<String> images ={};


   //load thumbnail image
   images.add(product.thumbnail);

   //assign thumbnail as selected image
   selectedProductImage.value = product.thumbnail;

   //get all images from the product model if not null
   if(product.images != null){
     images.addAll(product.images!);
   }

   //get all images from the product variables if not null
   if(product.productVariations != null || product.productVariations!.isNotEmpty){
     images.addAll(product.productVariations!.map((variation) => variation.image));
   }

   return images.toList();
 }

 ///show image popup
 void showEnlargedImage(String image){
   Get.to(
     fullscreenDialog: true,
       () => Dialog.fullscreen(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Padding(
                 padding: const EdgeInsets.symmetric(vertical: TSizes.defaultSpace * 2,horizontal: TSizes.defaultSpace),
                 child: CachedNetworkImage(imageUrl: image,),
             ),
             const SizedBox(height: TSizes.spaceBtwSections,),
             Align(
               alignment: Alignment.bottomCenter,
               child: SizedBox(
                 width: 150,
                 child: OutlinedButton(onPressed: () => Get.back(),child: const Text('Close'),),
               ),
             )
           ],
         ),
       )
   );
 }
}
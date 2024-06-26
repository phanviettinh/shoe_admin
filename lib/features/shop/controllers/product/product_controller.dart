import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/admin/screen/home/home_admin.dart';
import 'package:shoe_admin/admin/screen/products/show_product_admin.dart';
import 'package:shoe_admin/common/widgets/loaders/loader.dart';
import 'package:shoe_admin/data/repositories/products/product_reposotory.dart';
import 'package:shoe_admin/features/shop/controllers/all_product_controller.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/utils/constants/enums.dart';

class ProductController  extends GetxController{
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final product = Get.put(AllProductController());


  @override
  void onInit() {
    fetchFeaturedProducts();
    super.onInit();
  }

  void fetchFeaturedProducts() async{
    try{
      isLoading.value = true;

      // fetch products
      final products = await productRepository.getFeaturedProducts();

      //assign products
      featuredProducts.assignAll(products);
    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }finally{
      isLoading.value = false;
    }
  }

  // Hàm để load lại danh sách sản phẩm
  Future<void> fetchAllProducts() async {
    try {
      final products = await productRepository.fetchAllProducts();
      featuredProducts.assignAll(products);
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<List<ProductModel>> fetchAllFeaturedProducts() async{
    try{
      //fetch products
      final products = await productRepository.getAllFeaturedProducts();
      return products;
    }catch(e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> fetchAllFeaturedProductsNotIsFeatured() async{
    try{
      //fetch products
      final products = await productRepository.getAllFeaturedProductsNotIsFeatured();
      return products;
    }catch(e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  // get the product price or price range for variations
  String getProductPrice (ProductModel productModel){
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    //if no variations exist, return the simple price or sale price
    if(productModel.productType == ProductType.single.toString()){
      return (productModel.salePrice > 0 ? productModel.salePrice : productModel.price).toString();
    }else{
      // calculate the smallest and largest prices among variations
      for(var variation in productModel.productVariations!){
        // determine the price to consider (sale price if available, otherwise regular price)
        double priceToConsider = variation.salePrice > 0.0 ? variation.salePrice : variation.price;

        // update smallest and largest prices
        if(priceToConsider < smallestPrice){
          smallestPrice = priceToConsider;
        }

        if(priceToConsider > largestPrice){
          largestPrice = priceToConsider;
        }
      }
      // if smallest and largest prices  are the same, return a single price
      if(smallestPrice.isEqual(largestPrice)){
        return largestPrice.toString();
      }else{
        // otherwise, return a price range
        return "$smallestPrice - \$$largestPrice";
      }
    }
  }

  // calculate discount percentage
  String? calculateSalePercentage(double originalPrice, double? salePrice){
    if(salePrice == null || salePrice <= 0.0) return null;
    if(originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  // check product stock status
  String getProductStockStatus(int stock){
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }

}
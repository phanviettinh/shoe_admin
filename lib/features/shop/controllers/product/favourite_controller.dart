import 'dart:convert';

import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/loaders/loader.dart';
import 'package:shoe_admin/data/repositories/products/product_reposotory.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:shoe_admin/utils/local_storage/local_utility.dart';

class FavouritesController extends GetxController{
  static FavouritesController get instance => Get.find();

  ///variable
  final favourites = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initFavourites();
  }

  Future<void> initFavourites() async{
    final json = TLocalStorage.instance().readData('favourites');
    if(json != null){
      final storedFavourites = jsonDecode(json) as Map<String, dynamic>;
      favourites.assignAll(storedFavourites.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  bool isFavourite(String productId){
    return favourites[productId] ?? false;
  }

  void toggleFavouriteProduct(String productId){
    if(!favourites.containsKey(productId)){
      favourites[productId] = true;
      saveFavouritesToStorage();
      TLoaders.customToast(message: 'Product has been added to the WishList.');
    }else{
      TLocalStorage.instance().removeData(productId);
      favourites.remove(productId);
      saveFavouritesToStorage();
      favourites.refresh();
      TLoaders.customToast(message: 'Product has been removed from the WishList.');
    }
  }

  void saveFavouritesToStorage(){
    final encodedFavourites = json.encode(favourites);
    TLocalStorage.instance().saveData('favourites', encodedFavourites);
  }

  Future<List<ProductModel>> favouriteProducts() async{
    return await ProductRepository.instance.getFavouriteProducts(favourites.keys.toList());
  }
}
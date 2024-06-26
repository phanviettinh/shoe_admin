
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/features/shop/firebase/firebase_storage_service.dart';
import 'package:shoe_admin/features/shop/models/category_model.dart';
import 'package:shoe_admin/utils/exceptions/firebase_exception.dart';
import 'package:shoe_admin/utils/exceptions/format_exception.dart';
import 'package:shoe_admin/utils/exceptions/platform_exception.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  ///variable
  final _db = FirebaseFirestore.instance;

  ///get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _db.collection('Categories').get();
      final list = snapshot.docs.map((document) => CategoryModel.fromSnapShot(document)).toList();
      return list;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. please try again';
    }
  }

  /// Thêm danh muc moi
  Future<void> addCategory(CategoryModel category) async {
    try {
      await _db.collection('Categories').add(category.toJson());
    } catch (e) {
      throw 'Failed to add category: $e';
    }
  }

///get sub categories
  Future<List<CategoryModel>> getSubCategories(String categoryId) async{
    try{

      final snapshot = await _db.collection("Categories").where('ParentId',isEqualTo: categoryId).get();
      final result = snapshot.docs.map((e) => CategoryModel.fromSnapShot(e)).toList();
      return result;

    }on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. please try again';
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _db.collection('Categories').doc(categoryId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      throw 'Failed to delete product';
    }
  }

  Future<void> updateCategory(String categoryId, Map<String, dynamic> data) async {
    try {
      await _db.collection('Categories').doc(categoryId).update(data);
    } catch (e) {
      print('Error updating Brand: $e');
      throw 'Failed to update Brand';
    }
  }

  Stream<List<CategoryModel>> getCategoryStream() {
    return _db.collection('Categories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CategoryModel.fromQuerySnapshot(doc)).toList();
    });
  }
  Future<List<CategoryModel>> fetchCategoryByQuery(Query query) async {
    try {
      final querySnapshot = await query.get();
      final List<CategoryModel> productList = querySnapshot.docs
          .map((document) => CategoryModel.fromQuerySnapshot(document))
          .toList();
      return productList;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. please try again';
    }
  }

  ///upload category to the cloud firebase
  Future<void> uploadDummyData(List<CategoryModel> categories) async{
    try{
      //upload all the Category along with their images
      final storage = Get.put(TFirebaseStorageService());

      //loop through each category
      for(var category in categories) {
        //get image DATA link from the local assets
        final file = await storage.getImageDataFromAssets(category.image);

        //upload image and get its url
        final url = await storage.uploadImageData('Categories', file, category.name);

        //assign URL to Category.image  attribute
        category.image = url;

        //store category in fireStore
        await _db.collection("Categories").doc(category.id).set(category.toJson());
      }
   }on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. please try again';
    }
  }
}
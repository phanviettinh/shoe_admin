import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/features/shop/models/brand_model.dart';

import '../../../utils/exceptions/firebase_exception.dart';
import '../../../utils/exceptions/format_exception.dart';
import '../../../utils/exceptions/platform_exception.dart';

class BrandRepository extends GetxController{
  static BrandRepository get instance => Get.find();

  /// variable
  final _db = FirebaseFirestore.instance;

  ///get all category
  Future<List<BrandModel>> getAllBrands() async{
    try {
      final snapshot = await _db.collection('Brands').get();
      final result = snapshot.docs.map((e) => BrandModel.fromSnapshot(e)).toList();
      return result;

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


  ///get limited featured products
  // Future<List<BrandModel>> getFeaturedBrands() async {
  //   try {
  //     final snapshot = await _db
  //         .collection('Brands')
  //         .where('IsFeatured', isEqualTo: true)
  //         .limit(4)
  //         .get();
  //     return snapshot.docs.map((e) => BrandModel.fromSnapshot(e)).toList();
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const TFormatException();
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. please try again';
  //   }
  // }

  Future<List<BrandModel>> getBrandForCategory(String categoryId) async{
    try {
      QuerySnapshot brandCategoryQuery = await _db.collection('BrandCategory').where('categoryId', isEqualTo: categoryId).get();

      List<String> brandIds = brandCategoryQuery.docs.map((e) => e['brandId'] as String).toList();

      final brandQuery = await _db.collection('Brands').where(FieldPath.documentId, whereIn: brandIds).limit(2).get();

      List<BrandModel> brands = brandQuery.docs.map((e) => BrandModel.fromSnapshot(e)).toList();

      return brands;

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


  Stream<List<BrandModel>> getCategoryStream() {
    return _db.collection('Brands').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => BrandModel.fromQuerySnapshot(doc)).toList();
    });
  }

  ///update
  Future<void> updateBrand(String brandId, Map<String, dynamic> data) async {
    try {
      await _db.collection('Brands').doc(brandId).update(data);
    } catch (e) {
      print('Error updating Brand: $e');
      throw 'Failed to update Brand';
    }
  }

  ///add
  Future<void> addBrand(BrandModel brand) async {
    try {
      await _db.collection('Brands').add(brand.toJson());
    } catch (e) {
      throw 'Failed to add category: $e';
    }
  }

  ///delete
  Future<void> deleteBrand(String brandId) async {
    try {
      await _db.collection('Brands').doc(brandId).delete();
    } catch (e) {
      print('Error deleting Brand: $e');
      throw 'Failed to delete brand';
    }
  }
}
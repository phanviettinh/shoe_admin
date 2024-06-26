import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/features/shop/models/banner_model.dart';
import 'package:shoe_admin/utils/exceptions/firebase_exception.dart';
import 'package:shoe_admin/utils/exceptions/format_exception.dart';
import 'package:shoe_admin/utils/exceptions/platform_exception.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  ///variable
  final _db = FirebaseFirestore.instance;


  ///get all order related to current user
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final result = await _db.collection('Banners').where(
          'Active', isEqualTo: true).get();
      return result.docs.map((documentSnapshot) =>
          BannerModel.fromSnapShot(documentSnapshot)).toList();
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


  Stream<List<BannerModel>> getBannerStream() {
    return _db.collection('Banners').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => BannerModel.fromQuerySnapshot(doc))
          .toList();
    });
  }

  /// Thêm banner moi
  Future<void> addBanner(BannerModel banner) async {
    try {
      await _db.collection('Banners').add(banner.toJson());
    } catch (e) {
      throw 'Failed to add category: $e';
    }
  }

  // Cập nhật banner theo `imageUrl`
  Future<void> updateBannerByImageUrl(String imageUrl, BannerModel updatedBanner) async {
    try {
      // Tìm tài liệu có `imageUrl` tương ứng
      final query = await _db
          .collection('Banners')
          .where('ImageUrl', isEqualTo: imageUrl)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        await _db.collection('Banners').doc(doc.id).update({
          'ImageUrl': updatedBanner.imageUrl,
          'TargetScreen': updatedBanner.targetScreen,
          'Active': updatedBanner.active,
        });
      } else {
        throw Exception('Banner not found');
      }
    } catch (e) {
      print('Error updating banner: $e');
      throw e;
    }
  }

  // Xóa banner theo `imageUrl`
  Future<void> deleteBannerByImageUrl(String imageUrl) async {
    try {
      // Tìm tài liệu có `imageUrl` tương ứng
      final query = await _db
          .collection('Banners')
          .where('ImageUrl', isEqualTo: imageUrl)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        await _db.collection('Banners').doc(doc.id).delete();
      } else {
        throw Exception('Banner not found');
      }
    } catch (e) {
      print('Error deleting banner: $e');
      throw e;
    }
  }

}
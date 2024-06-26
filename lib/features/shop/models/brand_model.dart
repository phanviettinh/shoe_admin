import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  String id;
  String name;
  String image;
  bool? isFeatured;
  int? productsCount;
  BrandModel(
      {required this.id,
        required this.name,
        required this.image,
        this.isFeatured,
        this.productsCount});
  // Create empty func for clean code
  static BrandModel empty() => BrandModel(id: '', name: '', image: '');

  toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'ProductsCount': productsCount,
      'IsFeatured': isFeatured,
    };
  }

  // map json oriented document snapshot from firebase to userModel
  factory BrandModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return BrandModel.empty();
    return BrandModel(
        id: data['Id'],
        name: data['Name'],
        image: data['Image'],
        isFeatured: data['IsFeatured'] ?? false,
        productsCount: int.parse((data['ProductsCount'] ?? 0).toString()));
  }

  factory BrandModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BrandModel(
        id: data['Id'] ?? '',
        name: data['Name'] ?? '',
        productsCount: data['ProductsCount'] ?? '',
        image: data['Image'] ?? '',
        isFeatured: data['IsFeatured'] ?? false);
  }

  factory BrandModel.fromQuerySnapshot(DocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return BrandModel(id: document.id, name: data['Name'] ?? '', image: data['Image'] ?? '', isFeatured: data['IsFeatured'] ?? false

    );
  }
}

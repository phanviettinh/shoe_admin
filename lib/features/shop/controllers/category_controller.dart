import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoe_admin/admin/screen/home/home_admin.dart';
import 'package:shoe_admin/common/widgets/loaders/loader.dart';
import 'package:shoe_admin/data/repositories/categories/category_repository.dart';
import 'package:shoe_admin/data/repositories/products/product_reposotory.dart';
import 'package:shoe_admin/features/shop/models/category_model.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';

class CategoryController extends GetxController{
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
  final image = TextEditingController();
  final RxBool isFeatured = false.obs;
    final name = TextEditingController();
  final parentId = TextEditingController();
  final id = TextEditingController();

  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;

  final RxString selectedCategoryId = ''.obs;
  final RxString imageUrl = ''.obs; // Quan sát URL hình ảnh

  RxList<CategoryModel> filteredCategories = <CategoryModel>[].obs; // Added
  TextEditingController searchController = TextEditingController(); // Added

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
    listenToCategories();

  }

  /// Listen to category data changes
  void listenToCategories() {
    _categoryRepository.getCategoryStream().listen((categories) {
      allCategories.assignAll(categories);
      featuredCategories.assignAll(allCategories.where((category) => category.isFeatured && category.parentId.isEmpty).take(8).toList(),);
      filteredCategories.assignAll(allCategories); // Initialize filteredCategories
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    });
  }
  Future<void> fetchCategories() async{
    try{
      // show loader while loading categories
      isLoading.value = true;
      // fetch categories from data source (api)
      final categories = await _categoryRepository.getAllCategories();
      // update the categories list
      allCategories.assignAll(categories);
      //filter featured categories
      featuredCategories.assignAll(allCategories.where((category) => category.isFeatured && category.parentId.isEmpty).take(8).toList());
    }catch(e){
      TLoaders.errorSnackBar(title: 'oh snap!', message: e.toString());
    }finally{
      isLoading.value = false;
    }
  }

  Future<List<CategoryModel>> fetchCategoryByQuery(Query? query) async {
    try {
      if (query == null) return [];

      final products = await _categoryRepository.fetchCategoryByQuery(query);

      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }
  /// load selected category data
  Future<List<CategoryModel>> getSubCategories(String categoryId) async{
    try{
      final subCategories = await _categoryRepository.getSubCategories(categoryId);
      return subCategories;
    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// get category or sub-category products
  Future<List<ProductModel>> getCategoryProducts({required String categoryId, int limit = 4}) async{
    try{
      final products = await ProductRepository.instance.getProductsForCategory(categoryId: categoryId, limit: limit);
      return products;
    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

 ///add category
  Future<void> saveCategory() async {
    final category = CategoryModel(id: id.text, name: name.text, image: image.text, isFeatured: isFeatured.value,parentId: parentId.text);

    try {
      await _categoryRepository.addCategory(category);
      Get.back(result: true); // Trả kết quả thành công

      Get.snackbar('Success', 'Category added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category: $e');
    }
  }
  Future<void> pickAndUploadImage() async {
    try {
      // Chọn hình ảnh từ thư viện
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Tạo File từ đường dẫn đã chọn
        final file = File(pickedFile.path);

        // Lấy phần mở rộng của tệp
        final fileExtension = pickedFile.path.split('.').last;

        // Tạo tham chiếu đến Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('Categories/Images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Tải tệp lên Firebase Storage
        final uploadTask = ref.putFile(file);
        final snapshot = await uploadTask.whenComplete(() => {});

        // Lấy URL tải xuống của tệp đã tải lên
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Cập nhật URL hình ảnh và TextEditingController
        imageUrl.value = downloadUrl;
        image.text = downloadUrl;
        // Làm mới danh sách để cập nhật giao diện
        imageUrl.refresh();
        print('Image uploaded successfully: $downloadUrl');
      }
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar('Error', 'Failed to upload image. Please try again.');
    }
  }


  void showCategoryPickerDialog(BuildContext context) {
    final categoriesWithEmptyParentId = CategoryController.instance.allCategories
        .where((category) => category.parentId.isEmpty)
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ...categoriesWithEmptyParentId.map((category) {
                  return ListTile(
                    leading: Image.network(category.image, width: 50, height: 50),
                    title: Text(category.name),
                    onTap: () {
                      parentId.text = category.id;
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
                const Divider(),
               Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   ListTile(
                     leading: const Icon(Icons.clear),
                     title: const Text('No'),
                     onTap: () {
                       parentId.text = '';
                       Navigator.of(context).pop();
                     },
                   )
                 ],
               ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Filter categories by name
  void filterCategory(String query) {
    if (query.isEmpty) {
      filteredCategories.assignAll(allCategories);
    } else {
      filteredCategories.assignAll(allCategories.where((category) => category.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void resetCategory() {
    id.clear();
    image.clear();
    name.clear();
    isFeatured.value = false;
    parentId.clear();

  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _categoryRepository.deleteCategory(categoryId);
      featuredCategories.removeWhere((category) => category.id == categoryId);
      Get.snackbar('Success', 'Category deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }

  void setCategoryData(CategoryModel category) {
    image.text = category.image;
    name.text = category.name;
    imageUrl.value = category.image;
    isFeatured.value = category.isFeatured;
    parentId.text = category.parentId;
  }

  void resetCategoryData() {
    image.clear();
    name.clear();
    isFeatured.value = false;
    parentId.clear();
    imageUrl.value = '';
  }


  Future<void> updateCategoryData(CategoryModel category) async {
    final categoryId = selectedCategoryId.value = category.id;

    final data =  {
      'Image': image.text,
      'Name': name.text,
      'IsFeatured': isFeatured.value,
      'ParentId': parentId.text,
    };


    await _categoryRepository.updateCategory(categoryId, data);
    Get.back(result: true); // Trả kết quả thành công
    Get.snackbar('Success', 'Category updated successfully');

  }
}
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoe_admin/admin/screen/home/home_admin.dart';
import 'package:shoe_admin/common/widgets/loaders/loader.dart';
import 'package:shoe_admin/data/repositories/brands/brand_repository.dart';
import 'package:shoe_admin/data/repositories/products/product_reposotory.dart';
import 'package:shoe_admin/features/shop/models/brand_model.dart';
import 'package:shoe_admin/features/shop/models/product_model.dart';
import 'package:uuid/uuid.dart';

class BrandController extends GetxController{
  static BrandController get instance => Get.find();

  RxBool isLoading = true.obs;
  final RxList<BrandModel> featuredBrands = <BrandModel>[].obs;
  final RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final brandRepository = Get.put(BrandRepository());

  final textIdController = TextEditingController();
  final imageController = TextEditingController();
  final nameController = TextEditingController();
  final RxBool isFeatured = false.obs;
  final productsCount = TextEditingController();

  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final RxString selectedCategoryId = ''.obs;

  TextEditingController searchController = TextEditingController(); // Added
  RxList<BrandModel> filteredBrands = <BrandModel>[].obs; // Added

  final RxString imageUrl = ''.obs; // Quan sát URL hình ảnh

  @override
  void onInit() {
    getFeaturedBrand();
    super.onInit();
    listenToCategories();
  }
  ///load brands
  void listenToCategories() {
    brandRepository.getCategoryStream().listen((categories) {
      allBrands.assignAll(categories);
      featuredBrands.assignAll(allBrands.where((brand) => brand.isFeatured! ).take(10));
      filteredBrands.assignAll(allBrands); // Initialize filteredCategories
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    });
  }
  Future<void> getFeaturedBrand() async{
    try{
      isLoading.value = true;
      final brands = await brandRepository.getAllBrands();
      allBrands.assignAll(brands);
      featuredBrands.assignAll(allBrands.where((brand) => brand.isFeatured ?? false).take(4));
    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
    }finally{
      isLoading.value = false;
    }
  }
  ///get brands for category
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async{
    try{
      final brands = await brandRepository.getBrandForCategory(categoryId);
      return brands;
    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
      return [];
    }
  }

  ///get brands specific products from your data source
  Future<List<ProductModel>> getBrandProducts({required String brandId, int limit = -1}) async{
    try{
      final products = await ProductRepository.instance.getProductsForBrand(brandId: brandId, limit: limit);
      return products;
    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
      return [];
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
            .child('Brands/Images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Tải tệp lên Firebase Storage
        final uploadTask = ref.putFile(file);
        final snapshot = await uploadTask.whenComplete(() => {});

        // Lấy URL tải xuống của tệp đã tải lên
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Cập nhật URL hình ảnh và TextEditingController
        imageUrl.value = downloadUrl;
        imageController.text = downloadUrl;
        // Làm mới danh sách để cập nhật giao diện
        imageUrl.refresh();
        print('Image uploaded successfully: $downloadUrl');
      }
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar('Error', 'Failed to upload image. Please try again.');
    }
  }


  /// search brands by name
  void filterBrand(String query) {
    if (query.isEmpty) {
      filteredBrands.assignAll(allBrands);
    } else {
      filteredBrands.assignAll(allBrands.where((brand) => brand.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  ///update
  Future<void> updateBrandData(BrandModel brand) async {
    final brandId = selectedCategoryId.value = brand.id;

    final data =  {
      'Id': textIdController.text,
      'Image': imageController.text,
      'Name': nameController.text,
      'IsFeatured': isFeatured.value,
      'ProductsCount': 1,
    };


    await brandRepository.updateBrand(brandId, data);
    Get.back(result: true); // Trả kết quả thành công
    Get.snackbar('Success', 'Brand updated successfully');

  }

  Future<void> deleteBrand(String brandId) async {
    try {
      await brandRepository.deleteBrand(brandId);
      featuredBrands.removeWhere((brand) => brand.id == brandId);
      Get.snackbar('Success', 'Brand deleted successfully');

    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }

  ///add category
  Future<void> saveBrand() async {
    var uuid = const Uuid();
    String brandId = uuid.v4(); // Tạo ID ngẫu nhiên

    final brand = BrandModel(id: brandId, name: nameController.text, image: imageController.text, isFeatured: isFeatured.value,productsCount: 1,
    );

    try {
      await brandRepository.addBrand(brand);
      Get.back(result: true); // Trả kết quả thành công
      Get.snackbar('Success', 'Brand added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add brand: $e');
    }
  }

  void setBrandData(BrandModel brand) {
    imageController.text = brand.image;
    nameController.text = brand.name;
    imageUrl.value = brand.image;
    isFeatured.value = brand.isFeatured!;
    productsCount.text = brand.productsCount.toString();
  }

  void resetBrandData() {
    imageController.clear();
    nameController.clear();
    isFeatured.value = false;
    productsCount.clear();
    imageUrl.value = '';

  }
}
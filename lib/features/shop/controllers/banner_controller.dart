import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoe_admin/admin/screen/home/home_admin.dart';
import 'package:shoe_admin/common/widgets/loaders/loader.dart';
import 'package:shoe_admin/data/repositories/banners/banner_repository.dart';
import 'package:shoe_admin/features/shop/models/banner_model.dart';
import 'package:shoe_admin/features/shop/models/brand_model.dart';

class BannerController extends GetxController{

  ///variables
  final carousalCurrentIndex = 0.obs;
  final isLoading = false.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;
  final bannerRepository = Get.put(BannerRepository());

  final image = TextEditingController();
  final RxBool active = false.obs;
  final targetScreen = TextEditingController();

  final RxList<BannerModel> allBanner = <BannerModel>[].obs;
  RxList<BannerModel> filteredBanners = <BannerModel>[].obs; // Added
  TextEditingController searchController = TextEditingController(); //

  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;

  final targetScreenOptions = ['/search', '/home', '/store', '/favourites','/settings','/order','/all-products','/cart'].obs;

  final Rx<BannerModel?> currentBanner = Rx<BannerModel?>(null);

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
    listenToBanners();

  }

  ///update page navigational dots
  void updatePageIndicator(index){
    carousalCurrentIndex.value = index;
  }

  ///fetch controller
  void listenToBanners() {
    bannerRepository.getBannerStream().listen((banners) {
      allBanner.assignAll(banners);
      banners.assignAll(allBanner.where((banners) => banners.active ));
      filteredBanners.assignAll(allBanner); // Initialize filteredCategories
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    });
  }

  ///fetch controller
  Future<void> fetchBanners() async{
    try{
      //show loader
      isLoading.value = true;

      //fetch banners
      final bannerRepo = Get.put(BannerRepository());
      final banners = await bannerRepo.fetchBanners();

      //assign banners
      this.banners.assignAll(banners);

    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }finally{
      //remove loader
      isLoading.value = false;
    }
  }

  /// Filter banners by name
  void filterBanner(String query) {
    if (query.isEmpty) {
      filteredBanners.assignAll(allBanner);
    } else {
      filteredBanners.assignAll(allBanner.where((banner) => banner.targetScreen.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void setBannerData(BannerModel banner) {
    image.text = banner.imageUrl;
    targetScreen.text = banner.targetScreen;
    active.value = banner.active;
    currentBanner.value = banner;
  }


  void resetBannerData() {
    image.clear();
    targetScreen.clear();
    active.value = false;
    currentBanner.value = null;

  }

  ///load picker
  Future<void> pickAndUploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final ref = storage.ref().child('Banners/Images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      image.text = downloadUrl;
    }
  }

// Cập nhật banner hiện tại
  Future<void> updateCurrentBanner() async {
    if (currentBanner.value == null) return;

    final banner = currentBanner.value!;
    final updatedBanner = BannerModel(
      imageUrl: image.text,
      targetScreen: targetScreen.text,
      active: active.value,
    );

    try {
      await bannerRepository.updateBannerByImageUrl(banner.imageUrl, updatedBanner);
      Get.back(result: true); // Trả kết quả thành công
      Get.snackbar('Success', 'Banner updated successfully');

    } catch (e) {
      Get.snackbar('Error', 'Failed to update banner: $e');
    }
  }

  ///add banner
  Future<void> saveBanner() async {
    final banner = BannerModel( targetScreen: targetScreen.text, imageUrl: image.text, active: active.value);

    try {
      await bannerRepository.addBanner(banner);
      Get.back(result: true); // Trả kết quả thành công
      Get.snackbar('Success', 'Banner added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add Banner: $e');
    }
  }
  // Xóa banner hiện tại
  Future<void> deleteCurrentBanner() async {
    if (currentBanner.value == null) return;

    final banner = currentBanner.value!;
    await bannerRepository.deleteBannerByImageUrl(banner.imageUrl);
    Get.snackbar('Success', 'Banner deleted successfully');
  }
}

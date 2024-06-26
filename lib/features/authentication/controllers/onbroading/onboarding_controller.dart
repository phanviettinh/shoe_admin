import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoe_admin/admin/login/login_admin_screen.dart';
import 'package:shoe_admin/features/authentication/screens/login/login.dart';

class OnBoardingController extends GetxController{
  static OnBoardingController get instance => Get.find();


  ///Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  ///Update Current Index when Page Scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  ///Jump to the specific dot selected page.
  void dotNavigationClick(index){
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  ///Update Current Index & jump to next page
  void nextPage(){
    if(currentPageIndex.value == 2){
      final storage = GetStorage();

      if(kDebugMode){
        print('============= Get Storage Next Button =========');
        print(storage.read('IsFirstTime'));
      }
      storage.write('IsFirstTime', false);

      Get.offAll(const LoginAdminScreen());
    }else{
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  ///Update Current Index & jump to the next page
  void skipPage(){
    currentPageIndex.value = 2;
    pageController.jumpTo(2);
  }
}
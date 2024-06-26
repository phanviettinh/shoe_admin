import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/common/widgets/loaders/loader.dart';
import 'package:shoe_admin/data/repositories/authentication/authentication_repository.dart';
import 'package:shoe_admin/features/authentication/controllers/signup/network_manager.dart';
import 'package:shoe_admin/features/authentication/screens/password/reset_password.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/popups/full_screen_loader.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();

  ///variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  ///send reset password email
  sendPasswordResetEmail() async{
    try{
      //start loading
      TFullScreenLoader.openLoadingDialog('Processing your request...', TImages.loading);

      //check Internet connect
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if(!forgetPasswordFormKey.currentState!.validate()){
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      //remove loader
      TFullScreenLoader.stopLoading();

      //Show success screen
      TLoaders.successSnackBar(title: 'Email Sent',message: 'Email Link Sent to Reset your Password'.tr);

      //redirect
      Get.to(() =>  ResetPassword(email: email.text.trim()));


    }catch(e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap',message: e.toString());
    }
}

  resendPasswordResetEmail(String email) async{
    try{
      //start loading
      TFullScreenLoader.openLoadingDialog('Processing your request...', TImages.loading);

      //check Internet connect
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }

      //send email to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      //remove loader
      TFullScreenLoader.stopLoading();

      //Show success screen
      TLoaders.successSnackBar(title: 'Email Sent',message: 'Email Link Sent to Reset your Password'.tr);




    }catch(e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap',message: e.toString());
    }
  }
}
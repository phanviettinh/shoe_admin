import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/admin/screen/home/home_admin.dart';
import 'package:shoe_admin/common/widgets/loaders/loader.dart';
import 'package:shoe_admin/common/widgets/succes_screen/succes_screen.dart';
import 'package:shoe_admin/data/repositories/authentication/authentication_repository.dart';
import 'package:shoe_admin/data/repositories/users/user_repository.dart';
import 'package:shoe_admin/features/authentication/controllers/signup/network_manager.dart';
import 'package:shoe_admin/features/authentication/models/user_model.dart';
import 'package:shoe_admin/features/authentication/screens/signup/verify_email.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/constants/text_strings.dart';
import 'package:shoe_admin/utils/popups/full_screen_loader.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  ///variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;

  final email = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  final role = TextEditingController();

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  ///signup
  void signup() async {
    try {
      // Kiểm tra các trường nhập liệu có hợp lệ không
      if (!signupFormKey.currentState!.validate()) {
        return;
      }

      // Hiển thị loading dialog sau khi đã chắc chắn các trường nhập liệu hợp lệ
      TFullScreenLoader.openLoadingDialog(
          'We are processing your information...',
          TImages.loading
      );

      // Kiểm tra kết nối internet
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        TFullScreenLoader.stopLoading(); // Dừng loading nếu không có kết nối internet
        return;
      }

      // Kiểm tra chính sách riêng tư
      if (!privacyPolicy.value) {
        TFullScreenLoader.stopLoading(); // Dừng loading nếu không chấp nhận chính sách riêng tư
        TLoaders.warningSnackBar(
            title: 'Accept Privacy Policy',
            message: 'In order to create an account, you must read and accept the Privacy Policy & Terms of Use.'
        );
        return;
      }

      // Đăng ký người dùng trong hệ thống xác thực Firebase và lưu dữ liệu người dùng vào Firebase
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(
          email.text.trim(),
          password.text.trim()
      );

      // Lưu dữ liệu người dùng đã xác thực trong Firestore
      final newUser = UserModel(
          id: userCredential.user!.uid,
          email: email.text.trim(),
          firstName: firstName.text.trim(),
          username: userName.text.trim(),
          lastName: lastName.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          profilePicture: '', role: 'Client'
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Hiển thị thông báo thành công
      TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your account has been created! Verify your email to continue!'
      );

      // Chuyển hướng đến màn hình xác nhận email
      Get.to(() =>  VerifyEmailScreen(email: email.text.trim(),));

    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  ///signup
  void signupAdmin() async {
    try {
      // Kiểm tra các trường nhập liệu có hợp lệ không
      if (!signupFormKey.currentState!.validate()) {
        return;
      }

      // Hiển thị loading dialog sau khi đã chắc chắn các trường nhập liệu hợp lệ
      TFullScreenLoader.openLoadingDialog(
          'We are processing your information...',
          TImages.loading
      );

      // Kiểm tra kết nối internet
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        TFullScreenLoader.stopLoading(); // Dừng loading nếu không có kết nối internet
        return;
      }

      // Kiểm tra chính sách riêng tư
      if (!privacyPolicy.value) {
        TFullScreenLoader.stopLoading(); // Dừng loading nếu không chấp nhận chính sách riêng tư
        TLoaders.warningSnackBar(
            title: 'Accept Privacy Policy',
            message: 'In order to create an account, you must read and accept the Privacy Policy & Terms of Use.'
        );
        return;
      }

      // Đăng ký người dùng trong hệ thống xác thực Firebase và lưu dữ liệu người dùng vào Firebase
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(
          email.text.trim(),
          password.text.trim()
      );

      // Lưu dữ liệu người dùng đã xác thực trong Firestore
      final newUser = UserModel(
          id: userCredential.user!.uid,
          email: email.text.trim(),
          firstName: firstName.text.trim(),
          username: userName.text.trim(),
          lastName: lastName.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          profilePicture: '', role: 'Admin'
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);


      TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your account has been created.'
      );
      // Hiển thị thông báo thành công

      Get.offAll(() => const HomeScreenAdmin());

    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}

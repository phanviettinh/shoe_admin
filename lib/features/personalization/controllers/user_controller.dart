import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoe_admin/common/widgets/loaders/loader.dart';
import 'package:shoe_admin/data/repositories/authentication/authentication_repository.dart';
import 'package:shoe_admin/data/repositories/orders/orders_repository.dart';
import 'package:shoe_admin/data/repositories/users/user_repository.dart';
import 'package:shoe_admin/features/authentication/controllers/signup/network_manager.dart';
import 'package:shoe_admin/features/authentication/models/user_model.dart';
import 'package:shoe_admin/features/authentication/screens/login/login.dart';
import 'package:shoe_admin/features/personalization/screens/profile/widgets/re_auth_user_login_form.dart';
import 'package:shoe_admin/features/shop/controllers/product/order_controller.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/popups/full_screen_loader.dart';

import '../../shop/models/order_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();
  final orderRepository = Get.put(OrderRepository());
  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxList<UserModel> featuredUsers = <UserModel>[].obs;
  final isLoading = false.obs;


  RxList<UserModel> filteredUsers = <UserModel>[].obs; // Added
  TextEditingController searchController = TextEditingController(); // Added
  @override
  void onInit() {
    fetchUserRecord();
    super.onInit();
    listenToUsers();
  }

  void listenToUsers() {
    userRepository.getUserStream().listen((users) {
      allUsers.assignAll(users);
      featuredUsers.assignAll(allUsers.where((users) => users.role == 'Client' ).take(8).toList(),);
      filteredUsers.assignAll(allUsers); // Initialize filteredCategories
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    });
  }
  ///fetch user record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetail();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }
  // Phương thức để tìm user từ userId
  OrderModel? getOrderById(String orderId) {
    return OrderController.instance.orders.firstWhereOrNull((order) => order.id == orderId);
  }

  ///search
  void filterUser(String query) {
    if (query.isEmpty) {
      filteredUsers.value = allUsers.where((user) => user.role == 'Client').toList();
    } else {
      filteredUsers.value = allUsers.where((user) {
        return (user.fullName.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase())) &&
            user.role == 'Client';
      }).toList();
    }
  }

  ///delete
  Future<void> deleteUser(String  userId) async {
    try {
      // Hiển thị thông báo đang xử lý
      TFullScreenLoader.openLoadingDialog('Processing...', TImages.loading);

      // Lấy thông tin người dùng hiện tại
      final auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      // Xóa tài khoản khỏi Firebase Authentication
      await currentUser?.delete();

      // Xóa người dùng từ Firestore
      await FirebaseFirestore.instance.collection('Users').doc(userId).delete();

      // Cập nhật danh sách người dùng
      filteredUsers.removeWhere((user) => user.id == userId);

      // Hiển thị thông báo thành công
      TFullScreenLoader.stopLoading();
      Get.snackbar('Success', 'User deleted successfully');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
  ///save user record from any registration provider client
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      //refresh user record
      await fetchUserRecord();

      //if no record already stored
      if(user.value.id.isEmpty) {
        if (userCredentials != null) {
          final nameParts = UserModel.nameParts(
              userCredentials.user!.displayName ?? '');
          final userName = UserModel.generateUsername(
              userCredentials.user!.displayName ?? '');

          //map data
          final user = UserModel(
              id: userCredentials.user!.uid,
              email: userCredentials.user!.email ?? '',
              firstName: nameParts[0],
              username: userName,
              lastName: nameParts.length > 1
                  ? nameParts.sublist(1).join(' ')
                  : '',
              phoneNumber: userCredentials.user!.phoneNumber ?? '',
              profilePicture: userCredentials.user!.photoURL ?? '', role: 'Client'
          );

          //save user data
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(
          title: 'Data not saved',
          message: 'Something went wrong while save your information. You can re-save your data in your Profile');
    }
  }

  ///save user record from any registration provider admin
  Future<void> saveUserRecordAdmin(UserCredential? userCredentials) async {
    try {
      //refresh user record
      await fetchUserRecord();

      //if no record already stored
      if(user.value.id.isEmpty) {
        if (userCredentials != null) {
          final nameParts = UserModel.nameParts(
              userCredentials.user!.displayName ?? '');
          final userName = UserModel.generateUsername(
              userCredentials.user!.displayName ?? '');

          //map data
          final user = UserModel(
              id: userCredentials.user!.uid,
              email: userCredentials.user!.email ?? '',
              firstName: nameParts[0],
              username: userName,
              lastName: nameParts.length > 1
                  ? nameParts.sublist(1).join(' ')
                  : '',
              phoneNumber: userCredentials.user!.phoneNumber ?? '',
              profilePicture: userCredentials.user!.photoURL ?? '', role: 'Admin'
          );

          //save user data
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(
          title: 'Data not saved',
          message: 'Something went wrong while save your information. You can re-save your data in your Profile');
    }
  }


  // Existing delete account warning popup
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: 'Delete Account',
      middleText: 'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Delete'),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text('Cancel'),
      ),
    );
  }

  // Existing delete user account method with added functionality to store orders in a temporary collection
  void deleteUserAccount() async {
    try {
      TFullScreenLoader.openLoadingDialog('Processing...', TImages.loading);

      final auth = AuthenticationRepository.instance;
      final userId = auth.authUser.uid;

      // Fetch and store user orders temporarily
      final userOrders = await orderRepository.fetchUserOrders2(userId);
      orderRepository.addTemporaryOrders(userOrders);

      final provider = auth.authUser.providerData.map((e) => e.providerId).first;

      if (provider.isNotEmpty) {
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          TFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
          TLoaders.successSnackBar(
              title: 'Congratulations',
              message: 'Your account has been Deleted!'
          );
        } else if (provider == 'password') {
          TFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Existing re-authenticate method
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      TFullScreenLoader.openLoadingDialog('Processing...', TImages.loading);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      TFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your account has been Deleted!');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  ///upload profile image
  uploadUserProfilePicture() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 70,maxHeight: 512, maxWidth: 512);
      if(image != null){
        imageUploading.value = true;
        //upload image
        final imageUrl = await userRepository.uploadImage('Users/Images/Profile/', image);

        //update user image record
        Map<String,dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();
        TLoaders.successSnackBar(title: 'Congratulations',message: 'Your Profile Image has been updated!');
      }
    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!',message: 'Something went wrong: $e');
    } finally{
      imageUploading.value = false;
    }
  }


}
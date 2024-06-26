
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoe_admin/data/repositories/authentication/authentication_repository.dart';
import 'package:shoe_admin/features/authentication/models/user_model.dart';
import 'package:shoe_admin/utils/exceptions/firebase_auth_exception.dart';
import 'package:shoe_admin/utils/exceptions/firebase_exception.dart';
import 'package:shoe_admin/utils/exceptions/format_exception.dart';
import 'package:shoe_admin/utils/exceptions/platform_exception.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  ///Function to save user data to FireStore
  Future<void> saveUserRecord (UserModel user) async{
    try{
       await _db.collection("Users").doc(user.id).set(user.toJson());
    }on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    }on FormatException catch (_){
      throw const TFormatException();
    }on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch(e){
      throw 'Something went wrong. please try again';
    }
  }
  Stream<List<UserModel>> getUserStream() {
    return _db.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromQuerySnapshot(doc)).toList();
    });
  }

  ///Function to fetch user details based on user ID.
  Future<UserModel> fetchUserDetail() async{
    try{
      final documentSnapshot = await _db.collection("Users").doc(AuthenticationRepository.instance.authUser.uid).get();
      if(documentSnapshot.exists){
        return UserModel.fromSnapshot(documentSnapshot);
      }else{
        return UserModel.empty();
      }
    }on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    }on FormatException catch (_){
      throw const TFormatException();
    }on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch(e){
      throw 'Something went wrong. please try again';
    }
  }

  ///Function to update user data in fireStore
  Future<void> updateUserDetail(UserModel updatedUser) async{
    try{
     await _db.collection("Users").doc(updatedUser.id).update(updatedUser.toJson());
    }on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    }on FormatException catch (_){
      throw const TFormatException();
    }on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch(e){
      throw 'Something went wrong. please try again';
    }
  }

  ///Update any field in specific Users Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async{
    try{
      await _db.collection("Users").doc(AuthenticationRepository.instance.authUser.uid).update(json);
    }on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    }on FormatException catch (_){
      throw const TFormatException();
    }on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch(e){
      throw 'Something went wrong. please try again';
    }
  }

  ///Update any field in specific Users Collection
  Future<void> removeUserRecord(String userId) async{
    try{
      await _db.collection("Users").doc(userId).delete();
    }on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    }on FormatException catch (_){
      throw const TFormatException();
    }on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch(e){
      throw 'Something went wrong. please try again';
    }
  }

  ///upload any image
  Future<String> uploadImage(String path,XFile image) async{
    try{

      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;

    }on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    }on FormatException catch (_){
      throw const TFormatException();
    }on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch(e){
      throw 'Something went wrong. please try again';
    }
  }

  ///delete
  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection('Users').doc(userId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      throw 'Failed to delete product';
    }
  }
}

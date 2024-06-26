import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;

  CategoryModel({
      required this.id,
      required this.name,
      required this.image,
      required this.isFeatured,
        this.parentId = ''
      });

  ///empty helper function
 static CategoryModel empty() => CategoryModel(id: '', name: '', image: '', isFeatured: false);

 ///convert model to json structure so that you can store data in firebase
 Map<String, dynamic> toJson(){
   return{
     'Name': name,
     'Image': image,
     'ParentId': parentId,
     'IsFeatured': isFeatured,
   };
 }


 ///Map json oriented document snapshot form firebase to UserModel
 factory CategoryModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> document){
       if(document.data() != null){
         final data = document.data()!;

         //map json record to the model
         return CategoryModel(
             id: document.id,
             name: data['Name'] ?? '',
             image: data['Image'] ?? '',
             parentId: data['ParentId'] ?? '',
             isFeatured: data['IsFeatured'] ?? false
         );
       }else{
         return CategoryModel.empty();
       }
 }

  factory CategoryModel.fromQuerySnapshot(DocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return CategoryModel(id: document.id, name: data['Name'] ?? '', image: data['Image'] ?? '', isFeatured: data['IsFeatured'] ?? false

    );
  }

}


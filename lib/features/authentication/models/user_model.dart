import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoe_admin/utils/formatter/formatter.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  final String username;
  final String email;
  String phoneNumber;
  String profilePicture;
  String role;

  UserModel(
      {required this.id,
        required this.email,
        required this.firstName,
        required this.username,
        required this.lastName,
        required this.phoneNumber,
        required this.profilePicture,
        required this.role
      });

  String get fullName => '$firstName $lastName';

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);
  static List<String> nameParts(fullName) => fullName.split(" ");

  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toUpperCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toUpperCase() : "";

    String camelCaseUsername = "$firstName$lastName";
    String usernameWithPrefix = camelCaseUsername;
    return usernameWithPrefix;
  }

  static UserModel empty() => UserModel(
      id: '',
      email: '',
      firstName: '',
      username: '',
      lastName: '',
      phoneNumber: '',
      profilePicture: '', role: '');

  /// Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture, 'Role': role
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        username: data['Username'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '', role: data['Role'],
      );
    }else {
      return UserModel.empty();
    }
  }

  factory UserModel.fromQuerySnapshot(DocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return UserModel(
      id: document.id,
      firstName: data['FirstName'] ?? '',
      lastName: data['LastName'] ?? '',
      username: data['Username'] ?? '',
      email: data['Email'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      profilePicture: data['ProfilePicture'] ?? '', role: data['Role'] ?? 'Client',
    );

  }
}

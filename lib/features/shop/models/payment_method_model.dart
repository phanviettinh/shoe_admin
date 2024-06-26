import 'package:get/get.dart';

class PaymentMethodModel {
  String name;
  String image;

  PaymentMethodModel({required this.name, required this.image});

  static PaymentMethodModel empty() => PaymentMethodModel(name: '', image: '');
}
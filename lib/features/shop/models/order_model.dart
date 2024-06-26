import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoe_admin/features/personalization/models/address_model.dart';
import 'package:shoe_admin/features/shop/models/cart_item_model.dart';
import 'package:shoe_admin/utils/constants/enums.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class OrderModel {
  final String id;
  final String userId;
  OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? address;
  final DateTime deliveryDate;
   DateTime? searchDate;
  final List<CartItemModel> items;

  OrderModel(
      {required this.id,
      this.userId = '',
      required this.status,
      required this.totalAmount,
      required this.orderDate,
      this.paymentMethod = 'Paypal',
      this.address,
      required this.deliveryDate,
      required this.items,  this.searchDate});

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null
      ? THelperFunctions.getFormattedDate(deliveryDate!)
      : '';

  String get orderStatusText => status == OrderStatus.received
      ? 'Received'
      : status == OrderStatus.shipped
          ? 'Shipping'
          : status == OrderStatus.cancelled
              ? 'Cancelled'
              : 'Processing';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(),
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'address': address?.toJson(),
      'deliveryDate': deliveryDate,
      'searchDate': searchDate,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderModel(
        id: data['id'] as String,
        userId: data['userId'] as String,
        status: OrderStatus.values
            .firstWhere((element) => element.toString() == data['status']),
        totalAmount: data['totalAmount'] as double,
        orderDate: (data['orderDate'] as Timestamp).toDate(),
        paymentMethod: data['paymentMethod'] as String,
        address: AddressModel.fromMap(data['address'] as Map<String, dynamic>),
        deliveryDate: (data['deliveryDate'] as Timestamp).toDate(),
        searchDate: (data['searchDate'] as Timestamp).toDate(),
        items: (data['items'] as List<dynamic>)
            .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
            .toList());
  }

  factory OrderModel.fromQuerySnapshot(DocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return OrderModel(
        id: document.id,
        status: data['Status'] ?? '',
        totalAmount: double.parse((data['TotalAmount'] ?? 0.0).toString()),
        orderDate: (data['OrderDate'] as Timestamp).toDate(),
        items: (data['Items'] as List<dynamic>)
            .map((e) => CartItemModel.fromJson(e))
            .toList(), deliveryDate:  (data['OrderDate'] as Timestamp).toDate(), searchDate: (data['OrderDate'] as Timestamp).toDate());
  }

  @override
  String toString() {
    return id;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shoe_admin/data/repositories/authentication/authentication_repository.dart';
import 'package:shoe_admin/features/shop/models/order_model.dart';
import 'package:shoe_admin/utils/constants/enums.dart';

class OrderRepository extends GetxController{
  static OrderRepository get instance => Get.find();

  ///variable
  final _db = FirebaseFirestore.instance;

  List<OrderModel> temporaryOrders = [];

/// Fetch all orders for all users
  Future<List<OrderModel>> fetchAllUserOrders() async {
    try {
      // Get all user documents
      final usersSnapshot = await _db.collection('Users').get();

      List<OrderModel> allOrders = [];

      // Iterate through each user document to get their orders
      for (var userDoc in usersSnapshot.docs) {
        final ordersSnapshot = await _db
            .collection('Users')
            .doc(userDoc.id)
            .collection('Orders')
            .get();

        // Add each order to the list
        allOrders.addAll(ordersSnapshot.docs.map((e) => OrderModel.fromSnapshot(e)).toList());
      }

      return allOrders;
    } catch (e) {
      print('Error fetching all user orders: $e');
      throw 'Something went wrong while fetching all user orders. Try again later';
    }
  }

  Stream<List<OrderModel>> getOrderStream() {
    return _db.collection('Orders').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromQuerySnapshot(doc)).toList();
    });
  }

  ///xoa

  Future<void> deleteOrder(String userId ,String orderId,) async {
    try {
      final orderDoc = await _db.collection('Users').doc(userId).collection('Orders').doc(orderId).get();
      if (!orderDoc.exists) {
        throw 'Order does not exist in user\'s collection.';
      }

      // Xóa đơn hàng từ subcollection của người dùng
      await _db.collection('Users').doc(userId).collection('Orders').doc(orderId).delete();

      // Xóa đơn hàng từ collection chính nếu nó tồn tại ở đó
      final mainOrderDoc = await _db.collection('Orders').doc(orderId).get();
      if (mainOrderDoc.exists) {
        await _db.collection('Orders').doc(orderId).delete();
      }

      print('Order successfully deleted');
    } catch (e) {
      print('Error deleting order: $e');
      // Thông báo lỗi chi tiết cho người dùng
      throw 'Failed to delete order: $e';
    }
  }

  ///get order related to current user
  Future<List<OrderModel>> fetchUserOrders() async{
    try{
      final userId = AuthenticationRepository.instance.authUser.uid;
      if(userId.isEmpty) throw 'Unable to find user information. Try again in few minutes.';

      final result = await _db.collection('Users').doc(userId).collection('Orders').get();
      return result.docs.map((e) => OrderModel.fromSnapshot(e)).toList();
    }catch(e){
      throw 'Something went wrong while fetching order information. Try again later';
    }
  }
  Future<List<OrderModel>> fetchUserOrders2(String userId) async {
    try {
      final result = await _db.collection('Users').doc(userId).collection('Orders').get();
      return result.docs.map((e) => OrderModel.fromSnapshot(e)).toList();
    } catch (e) {
      throw 'Something went wrong while fetching order information. Try again later';
    }
  }

// New method to fetch all orders for admin

  Future<List<OrderModel>> fetchUserOrdersAdmin(String userId) async {
    try {
      if (userId.isEmpty) throw 'Unable to find user information. Try again in a few minutes.';

      final result = await _db.collection('Users').doc(userId).collection('Orders').get();
      return result.docs.map((e) => OrderModel.fromSnapshot(e)).toList();
    } catch (e) {
      throw 'Something went wrong while fetching order information. Try again later';
    }
  }

  Future<List<OrderModel>> fetchUserOrdersAdmin2(String userId, {String? orderId}) async {
    try {
      if (userId.isEmpty) {
        throw 'Unable to find user information. Try again in a few minutes.';
      }

      // Tham chiếu đến bộ sưu tập đơn hàng của người dùng
      final ordersCollection = _db.collection('Users').doc(userId).collection('Orders');

      // Kiểm tra nếu orderId được cung cấp
      final QuerySnapshot result;
      if (orderId != null) {
        // Lấy đơn hàng cụ thể dựa trên orderId
        result = await ordersCollection.where('id', isEqualTo: orderId).get();
      } else {
        // Lấy tất cả các đơn hàng nếu không có orderId
        result = await ordersCollection.get();
      }

      // Chuyển đổi kết quả thành danh sách các OrderModel
      return result.docs.map((e) => OrderModel.fromSnapshot(e)).toList();
    } catch (e) {
      throw 'Something went wrong while fetching order information. Try again later';
    }
  }


  //save and update orders
  Future<String> saveOrUpdateOrder(OrderModel order, String clientUserId) async {
    try {
      final orderRef = _db.collection('Users').doc(clientUserId).collection('Orders');

      // Kiểm tra xem đơn hàng đã tồn tại hay chưa
      final querySnapshot = await orderRef.where('id', isEqualTo: order.id).get();
      if (querySnapshot.docs.isEmpty) {
        // Nếu đơn hàng chưa tồn tại, thêm mới đơn hàng
        final docRef = await orderRef.add(order.toJson());
        return docRef.id;
      } else {
        // Nếu đơn hàng đã tồn tại, cập nhật đơn hàng
        final orderId = querySnapshot.docs.first.id;
        await orderRef.doc(orderId).update(order.toJson());
        return orderId;
      }
    } catch (e) {
      throw 'Failed to save or update order: $e';
    }
  }

  Future<List<OrderModel>> fetchReceivedOrders() async {
    try {
      List<OrderModel> receivedOrders = [];

      // Lấy ngày hôm nay
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      // Lấy tất cả các tài liệu người dùng
      final usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();

      // Lặp qua từng tài liệu người dùng để tìm đơn hàng có trạng thái "Received" và searchDate là ngày hôm nay
      for (var userDoc in usersSnapshot.docs) {
        final ordersSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userDoc.id)
            .collection('Orders')
            .where('status', isEqualTo: 'OrderStatus.received')
            .get();

        // Thêm các đơn hàng có trạng thái "Received" và searchDate là ngày hôm nay vào danh sách
        receivedOrders.addAll(ordersSnapshot.docs.map((e) => OrderModel.fromSnapshot(e)).toList());
      }

      return receivedOrders;
    } catch (e) {
      print('Error fetching received orders: $e'); // In lỗi chi tiết
      throw 'Something went wrong while fetching received orders. Try again later';
    }
  }


  // Phương thức để thêm đơn đặt hàng vào biến tạm thời
  void addTemporaryOrders(List<OrderModel> orders) {
    temporaryOrders.addAll(orders);
  }
}
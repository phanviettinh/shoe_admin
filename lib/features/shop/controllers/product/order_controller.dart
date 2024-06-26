import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shoe_admin/admin/screen/home/home_admin.dart';
import 'package:shoe_admin/common/widgets/loaders/loader.dart';
import 'package:shoe_admin/common/widgets/succes_screen/succes_screen.dart';
import 'package:shoe_admin/data/repositories/authentication/authentication_repository.dart';
import 'package:shoe_admin/data/repositories/orders/orders_repository.dart';
import 'package:shoe_admin/features/authentication/models/user_model.dart';
import 'package:shoe_admin/features/personalization/controllers/address_controller.dart';
import 'package:shoe_admin/features/personalization/controllers/user_controller.dart';
import 'package:shoe_admin/features/shop/controllers/product/cart_controller.dart';
import 'package:shoe_admin/features/shop/controllers/product/checkout_controller.dart';
import 'package:shoe_admin/features/shop/models/order_model.dart';
import 'package:shoe_admin/features/shop/screens/order/order_detail.dart';
import 'package:shoe_admin/navigation_menu.dart';
import 'package:shoe_admin/utils/constants/enums.dart';
import 'package:shoe_admin/utils/constants/image_strings.dart';
import 'package:shoe_admin/utils/popups/full_screen_loader.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  ///variable
  final cartController = Get.put(
      CartController()); // Use Get.find() to get the CartController instance
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());
  var orders = <OrderModel>[].obs;
  var receivedOrdersCount = 0.obs;
  var totalProfit = 0.0.obs;
  var showTotalAmount = false.obs;
  final RxList<OrderModel> allOrders = <OrderModel>[].obs;
  final RxList<OrderModel> filteredOrders = <OrderModel>[].obs;
  final searchController = TextEditingController();
  final isLoading = false.obs;

  final _db = FirebaseFirestore.instance;
  List<String> orderStatusOptions = [
    'Processing',
    'Shipping',
    'Received',
    'Cancelled'
  ];

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  RxString selectedDateRange = 'all'.obs;
  var receivedOrders = <OrderModel>[].obs;
  var totalProfitByDate = <DateTime, double>{}.obs;


  void updateDateRange() {
    switch (selectedDateRange.value) {
      case 'all':
        startDate.value = DateTime.now().subtract(const Duration(days: 7));
        endDate.value = DateTime.now();
        break;
      case 'today':
        startDate.value = DateTime.now();
        endDate.value = DateTime.now();
        break;
      case 'yesterday':
        startDate.value = DateTime.now().subtract(const Duration(days: 1));
        endDate.value = DateTime.now().subtract(const Duration(days: 1));
        break;

      case 'custom':
      // Tùy chỉnh không làm gì ở đây
        return;
    }
    filterOrdersByDate();
  }

  // Hàm lọc đơn hàng theo ngày và trạng thái 'received'
  void filterOrdersByDate() {
    if (startDate.value != null && endDate.value != null) {
      filteredOrders.value = allOrders.where((order) {
        DateTime orderDate = order.searchDate!;

          // Trường hợp tùy chỉnh sẽ sử dụng logic so sánh thông thường
          DateTime start = DateTime(startDate.value!.year, startDate.value!.month, startDate.value!.day);
          DateTime end = DateTime(endDate.value!.year, endDate.value!.month, endDate.value!.day, 23, 59, 59);
          return orderDate.isAfter(start.subtract(const Duration(seconds: 1))) &&
              orderDate.isBefore(end.add(const Duration(seconds: 1))) &&
              order.status == OrderStatus.received;
      }).toList();
      calculateTotalProfit();
    }
  }
  // Hàm tính tổng doanh thu từ đơn hàng có trạng thái receipt
  void calculateTotalProfit() {
    totalProfit.value = filteredOrders.fold(0.0, (sum, order) => sum + order.totalAmount);
    receivedOrdersCount.value = filteredOrders.length; // Đếm số đơn hàng trạng thái receipt
  }

  // Phương thức để tính tổng doanh thu theo ngày
  void calculateTotalProfitByDate() {
    totalProfitByDate.clear();

    for (var order in filteredOrders) {
      final orderDate = DateTime(order.searchDate!.year, order.searchDate!.month, order.searchDate!.day);
      if (totalProfitByDate.containsKey(orderDate)) {
        totalProfitByDate[orderDate] = totalProfitByDate[orderDate]! + order.totalAmount;
      } else {
        totalProfitByDate[orderDate] = order.totalAmount;
      }
    }
  }

  ///
  Future<List<OrderModel>> fetUserOrders() async {
    try {
      final userOrders = await orderRepository.fetchUserOrders();
      return userOrders;
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  ///
  Future<List<OrderModel>> fetUserOrdersClient(String userId) async {
    try {
      final userOrders = await orderRepository.fetchUserOrders2(userId);
      return userOrders;
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllUserOrders();

  }

  /// Listen to category data changes
  void listenToCategories() {
    orderRepository.getOrderStream().listen((orders) {
      allOrders.assignAll(orders);
      filteredOrders.assignAll(allOrders); // Initialize filteredCategories
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    });
  }

  Future<void> fetchAllUserOrders() async {
    try {
      final orders = await orderRepository.fetchAllUserOrders();
      allOrders.assignAll(orders);
      filteredOrders.assignAll(orders);
      print('Fetched orders: ${orders.length}'); // Debugging line
    } catch (e) {
      print('Error fetching all user orders: $e'); // Debugging line
    }
  }

  // Phương thức để tìm user từ userId
  UserModel? getUserById(String userId) {
    return UserController.instance.allUsers.firstWhereOrNull((user) =>
    user.id == userId);
  }

  // Phương thức để tìm user từ userId
  OrderModel? getOrderById(String orderId) {
    return allOrders.firstWhereOrNull((order) => order.id == orderId);
  }

  void filterOrders(String status) {
    if (status.isEmpty) {
      filteredOrders.assignAll(allOrders);
    } else {
      filteredOrders.assignAll(allOrders.where((order) =>
          order.orderStatusText.toLowerCase().contains(status.toLowerCase()))
          .toList());
    }
  }

  ///xoa
  // Phương thức xóa order
  Future<void> deleteOrder(String userId, String orderId) async {
    try {
      print(
          'Attempting to delete order with userId: $userId and orderId: $orderId');
      final docRef = _db.collection('Users').doc(userId)
          .collection('Orders')
          .doc(orderId);
      final orderSnapshot = await docRef.get();

      if (orderSnapshot.exists) {
        print('Order found, deleting...');
        await docRef.delete();
        Get.snackbar('Success', 'Order deleted successfully');
        print('Order deleted successfully');
      } else {
        print('Order does not exist $userId');
        Get.snackbar('Error', 'Order does not exist.');
      }
    } catch (e) {
      print('Error deleting order: $e');
      Get.snackbar('Error', 'Failed to delete order: $e');
    }
  }
 Future <void> deleteOrder2(String clientUserId, {String? orderId}) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Deleting your order', TImages.loading);

      // Lấy danh sách đơn hàng của người dùng từ cơ sở dữ liệu
      final clientOrders = await orderRepository.fetchUserOrdersAdmin2(clientUserId, orderId: orderId);

      // Tìm đơn hàng có trạng thái "pending" và cập nhật thành "cancelled"
      for (final order in clientOrders) {

        orderRepository.deleteOrder(clientUserId,order.id);
          // Thực hiện cập nhật trạng thái mới của đơn hàng

          Get.back(result: true);
          Get.snackbar('Success', 'Order deleted successfully');

          // Thoát khỏi vòng lặp sau khi cập nhật đơn hàng đầu tiên
          break;

      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  ///lay cac hoa don da nhan
  void fetchReceivedOrders() async {
    try {
      final orders = await orderRepository.fetchReceivedOrders();
      receivedOrdersCount.value = orders.length;
      totalProfit.value =
          orders.fold(0.0, (sum, order) => sum + order.totalAmount);
    } catch (e) {
      print('Error in fetchReceivedOrders: $e'); // In lỗi chi tiết
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  int countOrdersForUser(String userId) {
    return allOrders
        .where((order) => order.userId == userId)
        .length;
  }

  void processOrder(double totalAmount) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Processing your order', TImages.loading);

      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) return;

      // Thêm đơn hàng vào cơ sở dữ liệu với trạng thái "pending"
      final order = OrderModel(
        id: UniqueKey().toString(),
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        searchDate: DateTime.now(),
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now().add(const Duration(days: 3)),
        // Thêm 3 ngày vào ngày đặt
        items: cartController.cartItems.toList(),
      );


      // Lưu đơn hàng vào cơ sở dữ liệu và nhận ID của đơn hàng đã được lưu trữ
      await orderRepository.saveOrUpdateOrder(order, userId);

      // Xóa giỏ hàng sau khi đơn hàng được xử lý
      cartController.clearCart();

      // Hiển thị màn hình thành công
      Get.off(() =>
          SuccessScreen(
            image: TImages.checkerSuccess,
            title: 'Payment Success!',
            subtitle: 'Your item will be shipped soon',
            onPressed: () => Get.offAll(() => const NavigationMenu()),
          ));

      // Sau khi lưu đơn hàng, sử dụng ID được trả về để cập nhật đơn hàng nếu cần
      // Ví dụ: await orderRepository.updateOrder(updatedOrder, userId, orderId);
    } catch (e) {
      // Xử lý lỗi nếu có
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void processOrderAdmin(String clientUserId, double totalAmount, {String? orderId}) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Processing your order', TImages.loading);

      // Lấy danh sách đơn hàng của người dùng từ cơ sở dữ liệu
      final clientOrders = await orderRepository.fetchUserOrdersAdmin2(clientUserId, orderId: orderId);

      // Tìm đơn hàng có trạng thái "pending" và cập nhật thành "cancelled"
      for (final order in clientOrders) {
        if (order.status == OrderStatus.cancelled ||
            order.status == OrderStatus.shipped ||
            order.status == OrderStatus.received) {
          // Cập nhật trạng thái của đơn hàng thành "cancelled"
          order.status = OrderStatus.pending;

          // Thực hiện cập nhật trạng thái mới của đơn hàng
          await orderRepository.saveOrUpdateOrder(order, clientUserId);

          Get.back(result: true);
          Get.snackbar('Success', 'Order updated successfully');

          // Thoát khỏi vòng lặp sau khi cập nhật đơn hàng đầu tiên
          break;
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void cancelledOrder(double totalAmount) async {
    try {
      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) return;

      // Lấy danh sách đơn hàng của người dùng từ cơ sở dữ liệu
      final userOrders = await orderRepository.fetchUserOrders();


      // Tìm đơn hàng có trạng thái "pending" và cập nhật thành "cancelled"
      for (final order in userOrders) {
        if (order.status == OrderStatus.pending) {
          // Cập nhật trạng thái của đơn hàng thành "cancelled"
          order.status = OrderStatus.cancelled;

          // Thực hiện cập nhật trạng thái mới của đơn hàng
          await orderRepository.saveOrUpdateOrder(order, userId);

          Get.off(() =>
              SuccessScreen(
                image: TImages.checkerSuccess,
                title: 'Cancel Success!',
                subtitle: 'Your Order has been cancelled',
                onPressed: () => Get.offAll(() => const NavigationMenu()),
              ));

          // Thoát khỏi vòng lặp sau khi cập nhật đơn hàng đầu tiên
          break;
        }
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void cancelledOrderAdmin(String clientUserId, double totalAmount, {String? orderId}) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Processing your order', TImages.loading);

      // Lấy danh sách đơn hàng của người dùng từ cơ sở dữ liệu
      final clientOrders = await orderRepository.fetchUserOrdersAdmin2(clientUserId, orderId: orderId);


      // Tìm đơn hàng có trạng thái "pending" và cập nhật thành "cancelled"
      for (final order in clientOrders) {
        if (order.status == OrderStatus.pending ||
            order.status == OrderStatus.shipped ||
            order.status == OrderStatus.received) {
          // Cập nhật trạng thái của đơn hàng thành "cancelled"
          order.status = OrderStatus.cancelled;

          // Thực hiện cập nhật trạng thái mới của đơn hàng
          await orderRepository.saveOrUpdateOrder(order, clientUserId);

          Get.back(result: true);
          Get.snackbar('Success', 'Order updated successfully');

          // Thoát khỏi vòng lặp sau khi cập nhật đơn hàng đầu tiên
          break;
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void shippedOrder(String clientUserId, double totalAmount, {String? orderId}) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Processing your order', TImages.loading);

      // Lấy danh sách đơn hàng của người dùng từ cơ sở dữ liệu
      final clientOrders = await orderRepository.fetchUserOrdersAdmin2(clientUserId, orderId: orderId);


      // Tìm đơn hàng có trạng thái "pending" và cập nhật thành "shipped"
      for (final order in clientOrders) {
        if (order.status == OrderStatus.pending ||
            order.status == OrderStatus.cancelled ||
            order.status == OrderStatus.received) {
          // Cập nhật trạng thái của đơn hàng thành "shipped"
          order.status = OrderStatus.shipped;

          // Thực hiện cập nhật trạng thái mới của đơn hàng
          await orderRepository.saveOrUpdateOrder(order, clientUserId);

          Get.back(result: true);
          Get.snackbar('Success', 'Order updated successfully');


          // Thoát khỏi vòng lặp sau khi cập nhật đơn hàng đầu tiên
          break;
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void receivedOrder(double totalAmount) async {
    try {
      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) return;

      // Lấy danh sách đơn hàng của người dùng từ cơ sở dữ liệu
      final userOrders = await orderRepository.fetchUserOrders();


      // Tìm đơn hàng có trạng thái "pending" và cập nhật thành "cancelled"
      for (final order in userOrders) {
        if (order.status == OrderStatus.shipped) {
          // Cập nhật trạng thái của đơn hàng thành "cancelled"
          order.status = OrderStatus.received;
          order.searchDate = DateTime.now();
          // Thực hiện cập nhật trạng thái mới của đơn hàng
          await orderRepository.saveOrUpdateOrder(order, userId);

          Get.off(() =>
              SuccessScreen(
                image: TImages.checkerSuccess,
                title: 'Success!',
                subtitle: 'Thanks you very much!',
                onPressed: () => Get.offAll(() => const NavigationMenu()),
              ));

          // Thoát khỏi vòng lặp sau khi cập nhật đơn hàng đầu tiên
          break;
        }
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void receivedOrderAdmin(String clientUserId, double totalAmount, {String? orderId}) async {
    try {
      TFullScreenLoader.openLoadingDialog(
        'Processing your order', TImages.loading,
      );

      // Lấy danh sách đơn hàng của người dùng từ cơ sở dữ liệu
      final clientOrders = await orderRepository.fetchUserOrdersAdmin2(clientUserId, orderId: orderId);

      // Tìm đơn hàng có trạng thái "pending" và cập nhật thành "received"
      for (final order in clientOrders) {
        if (order.status == OrderStatus.pending || order.status == OrderStatus.shipped || order.status == OrderStatus.cancelled) {
          // Cập nhật trạng thái của đơn hàng thành "received"
          order.status = OrderStatus.received;

          // Cập nhật searchDate thành ngày hôm nay
          order.searchDate = DateTime.now();

          // Thực hiện cập nhật trạng thái mới của đơn hàng
          await orderRepository.saveOrUpdateOrder(order, clientUserId);

          Get.back(result: true);
          Get.snackbar('Success', 'Order updated successfully');

          // Thoát khỏi vòng lặp sau khi cập nhật đơn hàng đầu tiên
          break;
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void updateOrderDates(String clientUserId, DateTime newOrderDate, DateTime orderDate) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Updating order dates', TImages.loading);

      final clientOrders = await orderRepository.fetchUserOrdersAdmin(
          clientUserId);

      for (final order in clientOrders) {
        if (order.orderDate == orderDate) {
          // Create a copy of the order to modify its orderDate
          OrderModel updatedOrder = OrderModel(
            id: order.id,
            userId: order.userId,
            status: order.status,
            totalAmount: order.totalAmount,
            orderDate: newOrderDate,
            // Update orderDate here
            paymentMethod: order.paymentMethod,
            address: order.address,
            deliveryDate: order.deliveryDate,
            items: order.items, searchDate: order.searchDate,
          );

          // Save or update the updatedOrder
          await orderRepository.saveOrUpdateOrder(updatedOrder, clientUserId);

          Get.back(result: true);
          Get.snackbar('Success', 'Order date updated successfully');

          break;
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
  void updateDeliveryDates(String clientUserId, DateTime newDeliveryDate, DateTime deliveryDate) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Updating delivery dates', TImages.loading);

      final clientOrders = await orderRepository.fetchUserOrdersAdmin(
          clientUserId);

      for (final order in clientOrders) {
        if (order.deliveryDate == deliveryDate) {
          // Create a copy of the order to modify its orderDate
          OrderModel updatedOrder = OrderModel(
            id: order.id,
            userId: order.userId,
            status: order.status,
            totalAmount: order.totalAmount,
            orderDate: order.orderDate,
            // Update orderDate here
            paymentMethod: order.paymentMethod,
            address: order.address,
            deliveryDate: newDeliveryDate,
            items: order.items, searchDate: order.searchDate,
          );

          // Save or update the updatedOrder
          await orderRepository.saveOrUpdateOrder(updatedOrder, clientUserId);

          Get.back(result: true);
          Get.snackbar('Success', 'Delivery date updated successfully');

          break;
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
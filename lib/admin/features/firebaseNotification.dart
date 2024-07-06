import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shoe_admin/features/shop/controllers/product/order_controller.dart';

class FirebaseNotificationService {
  void setupFirebase(Function(RemoteMessage) onMessageReceived) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onMessageReceived(message);
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shoe_admin/admin/screen/home/widget/order_proceeds.dart';
import 'package:shoe_admin/admin/screen/orders/order_admin.dart';
import 'package:shoe_admin/admin/screen/orders/widgets/order_detail.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:shoe_admin/features/shop/controllers/product/order_controller.dart';

import 'package:shoe_admin/utils/constants/sizes.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;

import 'pdf_preview_screen.dart';


class ProceedDetail extends StatelessWidget {
  const ProceedDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final dark = THelperFunctions.isDarkMode(context);

    orderController.filterOrdersByDate();

    return Scaffold(
      appBar: const TAppbar(
        title: Text('Detail Revenue'),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Ngày đã tìm
              Obx(() {
                return Text(
                  'Date: ${orderController.selectedDateRange.value == 'custom'
                      ? '${DateFormat('dd/MM/yyyy').format(orderController.startDate.value!)} - ${DateFormat('dd/MM/yyyy').format(orderController.endDate.value!)}'
                      : orderController.selectedDateRange.value}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                );
              }),
              const SizedBox(height: 20),

              /// Số hóa đơn
              Obx(() {
                return Row(
                  children: [
                    const Icon(Icons.receipt, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Orders: ${orderController.receivedOrdersCount.value}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Iconsax.arrow_right_34),
                      onPressed: () => Get.to((const OrderProceeds(user: null))),
                    ),
                  ],
                );
              }),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Tổng tiền
              Obx(() {
                return Row(
                  children: [
                    const Icon(Icons.attach_money, color: Colors.amber),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Total Profit: ${orderController.totalProfit.value.toStringAsFixed(1)} \$',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 40),

              const Spacer(),

              /// Button Xuất báo cáo
              ElevatedButton.icon(
                onPressed: () async {
                  // Hiển thị xem trước PDF
                  await Get.to(() => PdfPreviewScreen(orderController: orderController));
                },
                icon: const Icon(Icons.import_export_outlined),
                label: const Text('Export Report'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Future<pw.Font> loadFont(String fontPath) async {
  final fontData = await rootBundle.load(fontPath);
  return pw.Font.ttf(fontData);
}

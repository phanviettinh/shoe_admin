

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:shoe_admin/admin/screen/home/widget/proceed_detail.dart';
import 'package:shoe_admin/common/widgets/appbar/appbar.dart';
import 'package:shoe_admin/features/shop/controllers/product/order_controller.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;

import 'pdf_preview_screen.dart';

class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({super.key, required this.orderController});
  final OrderController orderController;

  @override
  Widget build(BuildContext context) {
    orderController.filterOrdersByDate();

    return Scaffold(
      appBar: const TAppbar(
        title: Text('PDF Preview'),
        showBackArrow: true,
      ),
      body: PdfPreview(
        build: (format) => generatePdf(format, orderController),
        canChangeOrientation: false,
        canDebug: false,
        canChangePageFormat: false,
      ),
    );
  }
  Future<Uint8List> generatePdf(PdfPageFormat format, OrderController orderController) async {
    final pdf = pw.Document();

    // Load font
    final fontRegular = await loadFont('assets/fonts/Roboto-Regular.ttf');
    final fontBold = await loadFont('assets/fonts/Roboto-Bold.ttf');

    // Thông tin ngày tháng và lợi nhuận
    final dateRange = orderController.selectedDateRange.value == 'custom'
        ? '${DateFormat('dd/MM/yyyy').format(orderController.startDate.value!)} - ${DateFormat('dd/MM/yyyy').format(orderController.endDate.value!)}'
        : orderController.selectedDateRange.value;
    final orders = orderController.filteredOrders;
    final totalProfit = orderController.totalProfit.value.toStringAsFixed(1);

    // Số lượng đơn hàng mỗi trang
    final ordersPerPage = 10;

    // Tính tổng số trang
    final totalPages = (orders.length / ordersPerPage).ceil();

    for (var i = 0; i < totalPages; i++) {
      // Lấy dữ liệu đơn hàng cho trang hiện tại
      final startIndex = i * ordersPerPage;
      final endIndex = startIndex + ordersPerPage < orders.length
          ? startIndex + ordersPerPage
          : orders.length;

      final ordersOnPage = orders.sublist(startIndex, endIndex);

      pdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Tiêu đề và thông tin chung
                pw.Text(
                  'Cong Ty TTHH Phan Viet Tinh',
                  style: pw.TextStyle(font: fontBold, fontSize: 24),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Date: $dateRange',
                  style: pw.TextStyle(font: fontRegular, fontSize: 16, color: PdfColors.blue),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Orders: ${orders.length}',
                  style: pw.TextStyle(font: fontRegular, fontSize: 16),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Total Profit: $totalProfit \$',
                  style: pw.TextStyle(font: fontRegular, fontSize: 16),
                ),
                pw.SizedBox(height: 20),

                // Bảng dữ liệu đơn hàng cho trang hiện tại
                pw.Table.fromTextArray(
                  headers: ['Order ID', 'User', 'Order payment', 'Status', 'Total Amount'],
                  data: ordersOnPage.map((order) {
                    final user = orderController.getUserById(order.userId);
                    return [
                      order.id,
                      user?.fullName ?? 'Unknown',
                      DateFormat('dd/MM/yyyy').format(order.searchDate as DateTime),
                      order.orderStatusText,
                      '\$${order.totalAmount.toStringAsFixed(1)}',
                    ];
                  }).toList(),
                ),

                // Số trang
                pw.SizedBox(height: 20),
                pw.Text(
                  'Page ${i + 1} of $totalPages',
                  style: pw.TextStyle(font: fontRegular, fontSize: 12),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';


import '../../model/entity_booking.dart';
import '../../model/entity_room.dart';
import '../../service/service_object_box.dart';

class RoomSalesRow {
  final String roomNumber;
  int bookings;   // kitni bookings
  int nights;     // total nights
  double revenue; // total revenue

  RoomSalesRow({
    required this.roomNumber,
    this.bookings = 0,
    this.nights = 0,
    this.revenue = 0.0,
  });
}

class ControllerDailyRoomSales extends GetxController {
  late Box<EntityBooking> boxBooking;
  late Box<EntityRoom> boxRoom;

  final df = DateFormat("yyyy-MM-dd HH:mm");

  // Selected date
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // Table rows
  final RxList<RoomSalesRow> rows = <RoomSalesRow>[].obs;

  // Summary
  final RxDouble totalRevenue = 0.0.obs;

  @override
  void onInit() {
    final obj = Get.find<ServiceObjectBox>();
    boxBooking = obj.box<EntityBooking>();
    boxRoom = obj.box<EntityRoom>();

    loadForDate(DateTime.now());
    super.onInit();
  }

  DateTime parseDT(String s) {
    try {
      return df.parse(s);
    } catch (_) {
      return DateTime(2000);
    }
  }

  int _calcNights(EntityBooking b) {
    final ci = parseDT(b.checkInDate);
    final co = parseDT(b.checkOutDate);
    int days = co.difference(ci).inDays;
    if (days <= 0) days = 1;
    return days;
  }

  /// MAIN: load sales for a given date (based on checkOutDate)
  void loadForDate(DateTime date) {
    selectedDate.value = DateTime(date.year, date.month, date.day);

    final bookings = boxBooking.getAll();

    final Map<String, RoomSalesRow> map = {};
    double total = 0.0;

    for (final b in bookings) {
      // Sirf Checked-Out bookings
      if (b.status != "Checked-Out") continue;

      final co = parseDT(b.checkOutDate);
      if (co.year != date.year ||
          co.month != date.month ||
          co.day != date.day) {
        continue;
      }

      final room = b.room.target;
      final roomNo = room?.number ?? room?.roomUuid ?? "-";

      final key = roomNo;
      final row = map[key] ?? RoomSalesRow(roomNumber: roomNo);

      row.bookings += 1;
      row.nights += _calcNights(b);

      final net = b.totalBill - (b.discountPrice ?? 0.0);
      row.revenue += net;
      map[key] = row;
      total += net;
    }

    rows.value = map.values.toList()
      ..sort((a, b) => a.roomNumber.compareTo(b.roomNumber));
    totalRevenue.value = total;
  }

  /// Date picker from UI
  Future<void> pickDate(BuildContext context) async {
    final now = selectedDate.value;
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      loadForDate(picked);
    }
  }

//   /// Export daily room-wise sales as PDF
//   Future<void> exportPdf() async {
//     final pdf = pw.Document();
//
//     final dateStr = DateFormat("dd/MM/yyyy").format(selectedDate.value);
//
//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(20),
//         build: (context) {
//           return [
//             pw.Center(
//               child: pw.Text(
//                 "Daily Room-wise Sales Report",
//                 style: pw.TextStyle(
//                   fontSize: 20,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//             ),
//             pw.SizedBox(height: 5),
//             pw.Center(
//               child: pw.Text(
//                 "Date: $dateStr",
//                 style: const pw.TextStyle(fontSize: 12),
//               ),
//             ),
//             pw.SizedBox(height: 20),
//
//             pw.Text(
//               "Summary",
//               style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
//             ),
//             pw.SizedBox(height: 8),
//             pw.Text("Total Revenue: ${totalRevenue.value.toStringAsFixed(2)}"),
//
//             pw.SizedBox(height: 20),
//             pw.Text(
//               "Room-wise Details",
//               style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
//             ),
//             pw.SizedBox(height: 8),
//
//             pw.Table.fromTextArray(
//               headers: ["Room", "Bookings", "Nights", "Revenue"],
//               data: rows.map((r) {
//                 return [
//                   r.roomNumber,
//                   r.bookings.toString(),
//                   r.nights.toString(),
//                   r.revenue.toStringAsFixed(2),
//                 ];
//               }).toList(),
//             ),
//           ];
//         },
//       ),
//     );
//
//     await Printing.sharePdf(
//       bytes: await pdf.save(),
//       filename: "daily_room_sales_$dateStr.pdf",
//     );
//   }
}
